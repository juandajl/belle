import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';

enum MediaType { photo, reel }

/// Una prenda etiquetada en un post. Coordenadas normalizadas (0.0–1.0)
/// relativas al ancho/alto de la imagen, para que escalen a cualquier tamaño.
@freezed
class PostItem with _$PostItem {
  const PostItem._();

  const factory PostItem({
    required String id,
    required double x,
    required double y,
    String? name,
    String? brand,
    double? price,
    @Default('USD') String currency,
    String? shopUrl,
  }) = _PostItem;

  factory PostItem.fromMap(Map<String, dynamic> data) {
    return PostItem(
      id: data['id'] as String? ?? '',
      x: (data['x'] as num?)?.toDouble() ?? 0,
      y: (data['y'] as num?)?.toDouble() ?? 0,
      name: data['name'] as String?,
      brand: data['brand'] as String?,
      price: (data['price'] as num?)?.toDouble(),
      currency: data['currency'] as String? ?? 'USD',
      shopUrl: data['shopUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'x': x,
        'y': y,
        if (name != null && name!.trim().isNotEmpty) 'name': name!.trim(),
        if (brand != null && brand!.trim().isNotEmpty) 'brand': brand!.trim(),
        if (price != null) 'price': price,
        'currency': currency,
        if (shopUrl != null && shopUrl!.trim().isNotEmpty)
          'shopUrl': shopUrl!.trim(),
      };

  bool get hasInfo =>
      (name?.trim().isNotEmpty ?? false) ||
      (brand?.trim().isNotEmpty ?? false) ||
      price != null ||
      (shopUrl?.trim().isNotEmpty ?? false);
}

@freezed
class PostModel with _$PostModel {
  const PostModel._();

  const factory PostModel({
    required String id,
    required String userId,
    String? authorUsername,
    String? authorPhotoUrl,
    required String mediaUrl,
    @Default(MediaType.photo) MediaType mediaType,
    String? caption,
    @Default(<String>[]) List<String> hashtags,
    @Default(<PostItem>[]) List<PostItem> items,
    @Default(0) int likesCount,
    @Default(0) int commentsCount,
    @Default(0) int savesCount,
    required DateTime createdAt,
  }) = _PostModel;

  factory PostModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return PostModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      authorUsername: data['authorUsername'] as String?,
      authorPhotoUrl: data['authorPhotoUrl'] as String?,
      mediaUrl: data['mediaUrl'] as String? ?? '',
      mediaType: MediaType.values.byName(
        data['mediaType'] as String? ?? MediaType.photo.name,
      ),
      caption: data['caption'] as String?,
      hashtags: (data['hashtags'] as List?)?.cast<String>() ?? const [],
      items: (data['items'] as List?)
              ?.map((e) => PostItem.fromMap(e as Map<String, dynamic>))
              .toList() ??
          const [],
      likesCount: data['likesCount'] as int? ?? 0,
      commentsCount: data['commentsCount'] as int? ?? 0,
      savesCount: data['savesCount'] as int? ?? 0,
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'authorUsername': authorUsername,
        'authorPhotoUrl': authorPhotoUrl,
        'mediaUrl': mediaUrl,
        'mediaType': mediaType.name,
        if (caption != null) 'caption': caption,
        'hashtags': hashtags,
        'items': items.map((i) => i.toMap()).toList(),
        'likesCount': likesCount,
        'commentsCount': commentsCount,
        'savesCount': savesCount,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
