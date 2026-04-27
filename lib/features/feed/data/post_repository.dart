import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/services/storage_service.dart';
import '../domain/post_model.dart';

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

  Stream<List<PostModel>> watchFeed({int limit = 30}) {
    return _postsCol
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map(PostModel.fromFirestore).toList());
  }

  Stream<List<PostModel>> watchUserPosts(String userId, {int limit = 30}) {
    return _postsCol
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map(PostModel.fromFirestore).toList());
  }

  Future<void> deletePost({
    required String postId,
    required String userId,
  }) async {
    await _postsCol.doc(postId).delete();
    await _storage.deletePostImage(userId: userId, postId: postId);
  }

  static List<String> _extractHashtags(String? caption) {
    if (caption == null) return const [];
    final matches = RegExp(r'#(\w+)').allMatches(caption);
    return matches.map((m) => m.group(1)!.toLowerCase()).toSet().toList();
  }
}
