import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/auth_providers.dart';
import '../profile_providers.dart';

class FollowButton extends ConsumerWidget {
  const FollowButton({
    super.key,
    required this.targetUid,
    this.compact = false,
  });

  final String targetUid;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(authStateProvider).valueOrNull;
    if (me == null || me.uid == targetUid) return const SizedBox.shrink();

    final isFollowing =
        ref.watch(isFollowingProvider(targetUid)).valueOrNull ?? false;

    Future<void> toggle() async {
      final repo = ref.read(followRepositoryProvider);
      try {
        if (isFollowing) {
          await repo.unfollow(
            followerUid: me.uid,
            followedUid: targetUid,
          );
        } else {
          await repo.follow(
            followerUid: me.uid,
            followedUid: targetUid,
          );
        }
      } catch (_) {
        // silencioso por ahora
      }
    }

    if (isFollowing) {
      return OutlinedButton(
        onPressed: toggle,
        child: const Text('SIGUIENDO'),
      );
    }
    return FilledButton(
      onPressed: toggle,
      child: const Text('SEGUIR'),
    );
  }
}
