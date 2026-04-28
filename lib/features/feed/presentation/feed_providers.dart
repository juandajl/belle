import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/auth_providers.dart';
import '../../profile/presentation/profile_providers.dart';
import '../data/post_repository.dart';
import '../domain/post_model.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository();
});

/// Feed paginado. Mantiene una lista creciente de posts y soporta
/// `loadMore()` y `refresh()`.
final feedNotifierProvider =
    AsyncNotifierProvider<FeedNotifier, List<PostModel>>(FeedNotifier.new);

class FeedNotifier extends AsyncNotifier<List<PostModel>> {
  static const _pageSize = 12;
  DocumentSnapshot<Map<String, dynamic>>? _lastDoc;
  bool _hasMore = true;
  bool _loadingMore = false;

  @override
  Future<List<PostModel>> build() async {
    final result =
        await ref.read(postRepositoryProvider).fetchFeed(limit: _pageSize);
    _lastDoc = result.lastDoc;
    _hasMore = result.posts.length == _pageSize;
    return result.posts;
  }

  Future<void> refresh() async {
    _lastDoc = null;
    _hasMore = true;
    // No seteamos loading explícitamente — así el ListView permanece montado
    // y el RefreshIndicator anima el spinner correctamente hasta que llegue
    // la nueva data.
    state = await AsyncValue.guard(() async {
      final result =
          await ref.read(postRepositoryProvider).fetchFeed(limit: _pageSize);
      _lastDoc = result.lastDoc;
      _hasMore = result.posts.length == _pageSize;
      return result.posts;
    });
  }

  Future<void> loadMore() async {
    if (!_hasMore || _loadingMore || _lastDoc == null) return;
    final current = state.valueOrNull;
    if (current == null) return;

    _loadingMore = true;
    try {
      final result = await ref.read(postRepositoryProvider).fetchFeed(
            limit: _pageSize,
            startAfter: _lastDoc,
          );
      _lastDoc = result.lastDoc ?? _lastDoc;
      _hasMore = result.posts.length == _pageSize;
      state = AsyncValue.data([...current, ...result.posts]);
    } catch (_) {
      // Conservamos el estado anterior si hay error de red.
    } finally {
      _loadingMore = false;
    }
  }

  bool get hasMore => _hasMore;
}

/// Stream de posts de un usuario específico (perfil).
final userPostsProvider =
    StreamProvider.family<List<PostModel>, String>((ref, userId) {
  return ref.watch(postRepositoryProvider).watchUserPosts(userId);
});

/// Feed filtrado por la gente que el usuario actual sigue.
/// Versión simple sin paginación — lista los últimos 30 posts entre los
/// 30 primeros usuarios seguidos. Suficiente para MVP.
final followingFeedProvider = FutureProvider<List<PostModel>>((ref) async {
  final ids = ref.watch(myFollowingIdsProvider).valueOrNull ?? const [];
  if (ids.isEmpty) return const [];
  final result = await ref
      .watch(postRepositoryProvider)
      .fetchFollowingFeed(followingIds: ids, limit: 30);
  return result.posts;
});

/// Stream del documento del post — refleja contadores en vivo.
final postStreamProvider =
    StreamProvider.family.autoDispose<PostModel?, String>((ref, postId) {
  return ref.watch(postRepositoryProvider).watchPost(postId);
});

/// Indica si el usuario actual le dio like al post.
final hasLikedProvider =
    StreamProvider.family.autoDispose<bool, String>((ref, postId) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return Stream.value(false);
  return ref
      .watch(postRepositoryProvider)
      .watchHasLiked(postId: postId, userId: user.uid);
});

/// Indica si el usuario actual guardó el post en su colección.
final hasSavedProvider =
    StreamProvider.family.autoDispose<bool, String>((ref, postId) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return Stream.value(false);
  return ref
      .watch(postRepositoryProvider)
      .watchHasSaved(postId: postId, userId: user.uid);
});
