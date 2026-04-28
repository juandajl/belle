import 'package:cloud_firestore/cloud_firestore.dart';

import '../../feed/domain/post_model.dart';
import '../domain/referral_model.dart';

class ReferralRepository {
  ReferralRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('referrals');

  /// Registra un click sobre la prenda. No registra si el clicker es el
  /// mismo autor del post (no nos atribuimos clicks propios).
  Future<void> trackClick({
    required String referrerUserId,
    required String clickedByUserId,
    required String postId,
    required PostItem item,
  }) async {
    if (referrerUserId == clickedByUserId) return;
    if (item.shopUrl == null || item.shopUrl!.trim().isEmpty) return;

    await _col.add({
      'referrerUserId': referrerUserId,
      'clickedByUserId': clickedByUserId,
      'postId': postId,
      'itemId': item.id,
      'shopUrl': item.shopUrl,
      if (item.name != null) 'itemName': item.name,
      if (item.brand != null) 'itemBrand': item.brand,
      if (item.price != null) 'itemPrice': item.price,
      'itemCurrency': item.currency,
      'converted': false,
      'earnings': 0,
      'clickedAt': FieldValue.serverTimestamp(),
    });

    // Incrementamos el contador denormalizado en /users para el dashboard.
    try {
      await _firestore.collection('users').doc(referrerUserId).update({
        'totalClicks': FieldValue.increment(1),
      });
    } catch (_) {
      // Si las reglas rechazan o el doc no existe, el referido queda igual
      // registrado y el dashboard puede recalcular agregando.
    }
  }

  Stream<List<ReferralModel>> watchUserReferrals(
    String userId, {
    int limit = 100,
  }) {
    return _col
        .where('referrerUserId', isEqualTo: userId)
        .orderBy('clickedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map(ReferralModel.fromFirestore).toList());
  }
}
