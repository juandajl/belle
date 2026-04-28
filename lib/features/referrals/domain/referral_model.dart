import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'referral_model.freezed.dart';

/// Un click registrado: el usuario `clickedByUserId` tocó "VER EN TIENDA"
/// sobre una prenda etiquetada por `referrerUserId` en `postId`. Es la base
/// del sistema de afiliados de Belle.
@freezed
class ReferralModel with _$ReferralModel {
  const ReferralModel._();

  const factory ReferralModel({
    required String id,
    required String referrerUserId,
    required String clickedByUserId,
    required String postId,
    required String itemId,
    required String shopUrl,
    String? itemName,
    String? itemBrand,
    double? itemPrice,
    String? itemCurrency,
    @Default(false) bool converted,
    @Default(0) double earnings,
    required DateTime clickedAt,
  }) = _ReferralModel;

  factory ReferralModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return ReferralModel(
      id: doc.id,
      referrerUserId: data['referrerUserId'] as String? ?? '',
      clickedByUserId: data['clickedByUserId'] as String? ?? '',
      postId: data['postId'] as String? ?? '',
      itemId: data['itemId'] as String? ?? '',
      shopUrl: data['shopUrl'] as String? ?? '',
      itemName: data['itemName'] as String?,
      itemBrand: data['itemBrand'] as String?,
      itemPrice: (data['itemPrice'] as num?)?.toDouble(),
      itemCurrency: data['itemCurrency'] as String?,
      converted: data['converted'] as bool? ?? false,
      earnings: (data['earnings'] as num?)?.toDouble() ?? 0,
      clickedAt:
          (data['clickedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
