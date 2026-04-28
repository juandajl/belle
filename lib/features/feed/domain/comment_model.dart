import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_model.freezed.dart';

@freezed
class CommentModel with _$CommentModel {
  const CommentModel._();

  const factory CommentModel({
    required String id,
    required String postId,
    required String userId,
    String? username,
    String? userPhotoUrl,
    required String text,
    required DateTime createdAt,
  }) = _CommentModel;

  factory CommentModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    String postId,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return CommentModel(
      id: doc.id,
      postId: postId,
      userId: data['userId'] as String? ?? '',
      username: data['username'] as String?,
      userPhotoUrl: data['userPhotoUrl'] as String?,
      text: data['text'] as String? ?? '',
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
