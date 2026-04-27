import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/auth_providers.dart';
import '../feed_providers.dart';

class LikeButton extends ConsumerWidget {
  const LikeButton({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasLiked = ref.watch(hasLikedProvider(postId)).valueOrNull ?? false;

    return _AnimatedToggle(
      isActive: hasLiked,
      activeIcon: Icons.favorite,
      inactiveIcon: Icons.favorite_outline,
      activeColor: BelleColors.charcoal,
      onTap: () async {
        final user = ref.read(authStateProvider).valueOrNull;
        if (user == null) return;
        final repo = ref.read(postRepositoryProvider);
        try {
          if (hasLiked) {
            await repo.unlikePost(postId: postId, userId: user.uid);
          } else {
            await repo.likePost(postId: postId, userId: user.uid);
          }
        } catch (_) {
          // Reglas de Firestore o red — silencioso por ahora.
        }
      },
    );
  }
}

class SaveButton extends ConsumerWidget {
  const SaveButton({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasSaved = ref.watch(hasSavedProvider(postId)).valueOrNull ?? false;

    return _AnimatedToggle(
      isActive: hasSaved,
      activeIcon: Icons.bookmark,
      inactiveIcon: Icons.bookmark_outline,
      activeColor: BelleColors.charcoal,
      onTap: () async {
        final user = ref.read(authStateProvider).valueOrNull;
        if (user == null) return;
        final repo = ref.read(postRepositoryProvider);
        try {
          if (hasSaved) {
            await repo.unsavePost(postId: postId, userId: user.uid);
          } else {
            await repo.savePost(postId: postId, userId: user.uid);
          }
        } catch (_) {}
      },
    );
  }
}

class _AnimatedToggle extends StatefulWidget {
  const _AnimatedToggle({
    required this.isActive,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.activeColor,
    required this.onTap,
  });

  final bool isActive;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  State<_AnimatedToggle> createState() => _AnimatedToggleState();
}

class _AnimatedToggleState extends State<_AnimatedToggle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );

  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
    TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
  ]).animate(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(BelleSpacing.xs),
        child: ScaleTransition(
          scale: _scale,
          child: Icon(
            widget.isActive ? widget.activeIcon : widget.inactiveIcon,
            size: 22,
            color: widget.isActive
                ? widget.activeColor
                : BelleColors.charcoal,
          ),
        ),
      ),
    );
  }
}
