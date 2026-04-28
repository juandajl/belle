import 'package:cloud_firestore/cloud_firestore.dart';

class FollowRepository {
  FollowRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _sub(
    String userId,
    String name,
  ) =>
      _firestore.collection('users').doc(userId).collection(name);

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _firestore.collection('users').doc(uid);

  /// `followerUid` empieza a seguir a `followedUid`.
  /// Crea ambos lados de la relación + actualiza contadores en una sola batch.
  Future<void> follow({
    required String followerUid,
    required String followedUid,
  }) async {
    if (followerUid == followedUid) return;

    final batch = _firestore.batch();
    final now = FieldValue.serverTimestamp();

    batch.set(
      _sub(followerUid, 'following').doc(followedUid),
      {'createdAt': now},
    );
    batch.set(
      _sub(followedUid, 'followers').doc(followerUid),
      {'createdAt': now},
    );
    batch.update(_userDoc(followerUid), {
      'followingCount': FieldValue.increment(1),
    });
    batch.update(_userDoc(followedUid), {
      'followersCount': FieldValue.increment(1),
    });

    await batch.commit();
  }

  Future<void> unfollow({
    required String followerUid,
    required String followedUid,
  }) async {
    if (followerUid == followedUid) return;

    final batch = _firestore.batch();
    batch.delete(_sub(followerUid, 'following').doc(followedUid));
    batch.delete(_sub(followedUid, 'followers').doc(followerUid));
    batch.update(_userDoc(followerUid), {
      'followingCount': FieldValue.increment(-1),
    });
    batch.update(_userDoc(followedUid), {
      'followersCount': FieldValue.increment(-1),
    });

    await batch.commit();
  }

  Stream<bool> watchIsFollowing({
    required String followerUid,
    required String followedUid,
  }) {
    return _sub(followerUid, 'following')
        .doc(followedUid)
        .snapshots()
        .map((s) => s.exists);
  }

  /// Stream de los IDs de los usuarios que sigue `userId`.
  /// Útil para filtrar el feed "Siguiendo".
  Stream<List<String>> watchFollowingIds(String userId) {
    return _sub(userId, 'following').snapshots().map(
          (snap) => snap.docs.map((d) => d.id).toList(),
        );
  }
}
