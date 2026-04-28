import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/domain/user_model.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../feed/data/comment_repository.dart';
import '../../feed/domain/comment_model.dart';
import '../data/follow_repository.dart';

final followRepositoryProvider = Provider<FollowRepository>((ref) {
  return FollowRepository();
});

final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  return CommentRepository();
});

/// Doc de un usuario por uid (para ver perfiles ajenos).
final userByIdProvider =
    StreamProvider.family<UserModel?, String>((ref, uid) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .snapshots()
      .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
});

/// `true` si el usuario actual sigue al usuario `targetUid`.
final isFollowingProvider =
    StreamProvider.family.autoDispose<bool, String>((ref, targetUid) {
  final me = ref.watch(authStateProvider).valueOrNull;
  if (me == null || me.uid == targetUid) return Stream.value(false);
  return ref.watch(followRepositoryProvider).watchIsFollowing(
        followerUid: me.uid,
        followedUid: targetUid,
      );
});

/// IDs de los usuarios que sigue el usuario actual.
final myFollowingIdsProvider = StreamProvider<List<String>>((ref) {
  final me = ref.watch(authStateProvider).valueOrNull;
  if (me == null) return Stream.value(const []);
  return ref.watch(followRepositoryProvider).watchFollowingIds(me.uid);
});

/// Comentarios de un post.
final postCommentsProvider =
    StreamProvider.family.autoDispose<List<CommentModel>, String>(
  (ref, postId) =>
      ref.watch(commentRepositoryProvider).watchComments(postId),
);
