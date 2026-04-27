import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/services/storage_service.dart';
import '../domain/post_model.dart';

typedef FeedPage = ({
  List<PostModel> posts,
  DocumentSnapshot<Map<String, dynamic>>? lastDoc,
});

class PostRepository {
  PostRepository({
    FirebaseFirestore? firestore,
    StorageService? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? StorageService();

  final FirebaseFirestore _firestore;
  final StorageService _storage;

  CollectionReference<Map<String, dynamic>> get _postsCol =>
      _firestore.collection('posts');

  Future<PostModel> createPost({
    required String userId,
    required String? authorUsername,
    required String? authorPhotoUrl,
    required File imageFile,
    String? caption,
    List<PostItem> items = const [],
  }) async {
    final docRef = _postsCol.doc();
    final postId = docRef.id;

    final imageUrl = await _storage.uploadPostImage(
      userId: userId,
      postId: postId,
      file: imageFile,
    );

    final post = PostModel(
      id: postId,
      userId: userId,
      authorUsername: authorUsername,
      authorPhotoUrl: authorPhotoUrl,
      mediaUrl: imageUrl,
      caption: caption?.trim().isEmpty ?? true ? null : caption!.trim(),
      hashtags: _extractHashtags(caption),
      items: items,
      createdAt: DateTime.now(),
    );

    await docRef.set(post.toFirestore());
    return post;
  }

  /// Una página del feed cronológico global. Pasar [startAfter] para paginar.
  Future<FeedPage> fetchFeed({
    int limit = 12,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
  }) async {
    Query<Map<String, dynamic>> query =
        _postsCol.orderBy('createdAt', descending: true).limit(limit);
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    final snap = await query.get();
    final posts = snap.docs.map(PostModel.fromFirestore).toList();
    return (
      posts: posts,
      lastDoc: snap.docs.isEmpty ? null : snap.docs.last,
    );
  }

  Stream<List<PostModel>> watchUserPosts(String userId, {int limit = 30}) {
    return _postsCol
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) {
      final posts = snap.docs.map(PostModel.fromFirestore).toList();
      posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return posts.take(limit).toList();
    });
  }

  Future<void> deletePost({
    required String postId,
    required String userId,
  }) async {
    await _postsCol.doc(postId).delete();
    await _storage.deletePostImage(userId: userId, postId: postId);
  }

  // --- Likes ---------------------------------------------------------

  Future<void> likePost({
    required String postId,
    required String userId,
  }) async {
    await _firestore.runTransaction((txn) async {
      final likeRef =
          _postsCol.doc(postId).collection('likes').doc(userId);
      final likeSnap = await txn.get(likeRef);
      if (likeSnap.exists) return;
      txn.set(likeRef, {'createdAt': FieldValue.serverTimestamp()});
      txn.update(_postsCol.doc(postId), {
        'likesCount': FieldValue.increment(1),
      });
    });
  }

  Future<void> unlikePost({
    required String postId,
    required String userId,
  }) async {
    await _firestore.runTransaction((txn) async {
      final likeRef =
          _postsCol.doc(postId).collection('likes').doc(userId);
      final likeSnap = await txn.get(likeRef);
      if (!likeSnap.exists) return;
      txn.delete(likeRef);
      txn.update(_postsCol.doc(postId), {
        'likesCount': FieldValue.increment(-1),
      });
    });
  }

  Stream<bool> watchHasLiked({
    required String postId,
    required String userId,
  }) {
    return _postsCol
        .doc(postId)
        .collection('likes')
        .doc(userId)
        .snapshots()
        .map((snap) => snap.exists);
  }

  // --- Saves ---------------------------------------------------------

  Future<void> savePost({
    required String postId,
    required String userId,
  }) async {
    await _firestore.runTransaction((txn) async {
      final saveRef =
          _postsCol.doc(postId).collection('saves').doc(userId);
      final saveSnap = await txn.get(saveRef);
      if (saveSnap.exists) return;
      txn.set(saveRef, {'createdAt': FieldValue.serverTimestamp()});
      txn.update(_postsCol.doc(postId), {
        'savesCount': FieldValue.increment(1),
      });
    });
  }

  Future<void> unsavePost({
    required String postId,
    required String userId,
  }) async {
    await _firestore.runTransaction((txn) async {
      final saveRef =
          _postsCol.doc(postId).collection('saves').doc(userId);
      final saveSnap = await txn.get(saveRef);
      if (!saveSnap.exists) return;
      txn.delete(saveRef);
      txn.update(_postsCol.doc(postId), {
        'savesCount': FieldValue.increment(-1),
      });
    });
  }

  Stream<bool> watchHasSaved({
    required String postId,
    required String userId,
  }) {
    return _postsCol
        .doc(postId)
        .collection('saves')
        .doc(userId)
        .snapshots()
        .map((snap) => snap.exists);
  }

  /// Stream del documento del post (para reflejar contadores en tiempo real).
  Stream<PostModel?> watchPost(String postId) {
    return _postsCol.doc(postId).snapshots().map(
          (doc) => doc.exists ? PostModel.fromFirestore(doc) : null,
        );
  }

  static List<String> _extractHashtags(String? caption) {
    if (caption == null) return const [];
    final matches = RegExp(r'#(\w+)').allMatches(caption);
    return matches.map((m) => m.group(1)!.toLowerCase()).toSet().toList();
  }
}
