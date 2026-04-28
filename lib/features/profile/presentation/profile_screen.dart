import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../feed/presentation/feed_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: BelleColors.ivory,
      appBar: AppBar(
        title: const Text('PERFIL'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, size: 20),
            tooltip: 'Cerrar sesión',
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
      body: userAsync.when(
        loading: () => const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 1.2),
          ),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (user) {
          if (user == null) return const SizedBox.shrink();
          final postsAsync = ref.watch(userPostsProvider(user.uid));

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: BelleSpacing.lg,
                    vertical: BelleSpacing.lg,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: BelleColors.gold,
                            width: 1.5,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 44,
                          backgroundColor: BelleColors.rosePaleSoft,
                          backgroundImage: user.photoUrl != null
                              ? CachedNetworkImageProvider(user.photoUrl!)
                              : null,
                          child: user.photoUrl == null
                              ? const Icon(
                                  Icons.person_outline,
                                  size: 40,
                                  color: BelleColors.charcoalMuted,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: BelleSpacing.md),
                      Text(
                        '@${user.username ?? '...'}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      if (user.displayName != null) ...[
                        const SizedBox(height: BelleSpacing.xs),
                        Text(
                          user.displayName!,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: BelleColors.charcoalMuted,
                          ),
                        ),
                      ],
                      if (user.bio?.trim().isNotEmpty ?? false) ...[
                        const SizedBox(height: BelleSpacing.sm),
                        Text(
                          user.bio!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: BelleColors.charcoal,
                            height: 1.4,
                          ),
                        ),
                      ],
                      const SizedBox(height: BelleSpacing.lg),
                      _Stats(
                        followers: user.followersCount,
                        following: user.followingCount,
                        clicks: user.totalClicks,
                        earnings: user.totalEarnings,
                        onEarningsTap: () =>
                            context.push(AppRoutes.earnings),
                      ),
                      const SizedBox(height: BelleSpacing.lg),
                    ],
                  ),
                ),
              ),
              postsAsync.when(
                loading: () => const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(BelleSpacing.xl),
                    child: Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 1.2),
                      ),
                    ),
                  ),
                ),
                error: (e, _) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(BelleSpacing.lg),
                    child: Text(
                      'Error cargando posts: $e',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: BelleColors.charcoalMuted,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                data: (posts) {
                  if (posts.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(BelleSpacing.xl),
                        child: Center(
                          child: Text(
                            'Aún no has publicado outfits',
                            style: GoogleFonts.inter(
                              color: BelleColors.charcoalMuted,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: BelleSpacing.xs,
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final post = posts[i];
                          return AspectRatio(
                            aspectRatio: 1,
                            child: CachedNetworkImage(
                              imageUrl: post.mediaUrl,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Container(
                                color: BelleColors.ivoryDeep,
                              ),
                            ),
                          );
                        },
                        childCount: posts.length,
                      ),
                    ),
                  );
                },
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: BelleSpacing.xxl),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats({
    required this.followers,
    required this.following,
    required this.clicks,
    required this.earnings,
    required this.onEarningsTap,
  });

  final int followers;
  final int following;
  final int clicks;
  final double earnings;
  final VoidCallback onEarningsTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatCell(value: '$followers', label: 'SEGUIDORES'),
        _Divider(),
        _StatCell(value: '$following', label: 'SIGUIENDO'),
        _Divider(),
        _StatCell(
          value: '$clicks',
          label: 'CLICKS',
          onTap: onEarningsTap,
          highlighted: true,
        ),
      ],
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.value,
    required this.label,
    this.onTap,
    this.highlighted = false,
  });

  final String value;
  final String label;
  final VoidCallback? onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: highlighted ? BelleColors.gold : BelleColors.charcoal,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
    if (onTap == null) return content;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(BelleRadii.small),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: BelleSpacing.sm,
          vertical: BelleSpacing.xs,
        ),
        child: content,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: BelleColors.outline,
    );
  }
}
