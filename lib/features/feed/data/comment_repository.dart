import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/domain/user_model.dart';
import '../domain/comment_model.dart';

class CommentRepository {
  CommentRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _postDoc(String postId) =>
      _firestore.collection('posts').doc(postId);

  CollectionReference<Map<String, dynamic>> _commentsCol(String postId) =>
      _postDoc(postId).collection('comments');

  Future<void> addComment({
    required String postId,
    required UserModel author,
    required String text,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final docRef = _commentsCol(postId).doc();
    final batch = _firestore.batch();

    batch.set(docRef, {
      'userId': author.uid,
      'username': author.username,
      'userPhotoUrl': author.photoUrl,
      'text': trimmed,
      'createdAt': FieldValue.serverTimestamp(),
    });
    batch.update(_postDoc(postId), {
      'commentsCount': FieldValue.increment(1),
    });

    await batch.commit();
  }

  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    final batch = _firestore.batch();
    batch.delete(_commentsCol(postId).doc(commentId));
    batch.update(_postDoc(postId), {
      'commentsCount': FieldValue.increment(-1),
    });
    await batch.commit();
  }

  Stream<List<CommentModel>> watchComments(String postId, {int limit = 100}) {
    return _commentsCol(postId)
        .orderBy('createdAt', descending: false)
        .limit(limit)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => CommentModel.fromFirestore(d, postId))
              .toList(),
        );
  }
}
