import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/post_repository.dart';
import '../domain/post_model.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository();
});

/// Stream del feed global (los posts más recientes de todos los usuarios).
final feedPostsProvider = StreamProvider<List<PostModel>>((ref) {
  return ref.watch(postRepositoryProvider).watchFeed();
});

/// Stream de posts de un usuario específico (perfil).
final userPostsProvider =
    StreamProvider.family<List<PostModel>, String>((ref, userId) {
  return ref.watch(postRepositoryProvider).watchUserPosts(userId);
});
