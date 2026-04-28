import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/verified_badge.dart';
import '../../auth/domain/user_model.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../feed/presentation/feed_providers.dart';
import 'profile_providers.dart';
import 'widgets/follow_button.dart';

/// Pantalla de perfil. Si [userId] es null o coincide con el usuario actual,
/// muestra controles de auto-perfil (editar / cerrar sesión / ganancias).
/// Si es otro usuario, muestra "Seguir/Siguiendo".
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, this.userId});

  final String? userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(currentUserProvider).valueOrNull;
    final isOwn = userId == null || userId == me?.uid;

    if (isOwn) {
      if (me == null) {
        return const Scaffold(
          body: Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 1.2),
            ),
          ),
        );
      }
      return _ProfileBody(user: me, isOwn: true, ref: ref);
    }

    final userAsync = ref.watch(userByIdProvider(userId!));
    return userAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 1.2),
          ),
        ),
      ),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('Usuario no encontrado')),
          );
        }
        return _ProfileBody(user: user, isOwn: false, ref: ref);
      },
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({
    required this.user,
    required this.isOwn,
    required this.ref,
  });

  final UserModel user;
  final bool isOwn;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(userPostsProvider(user.uid));

    return Scaffold(
      backgroundColor: BelleColors.ivory,
      appBar: AppBar(
        leading: isOwn
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back, size: 22),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
        title: Text(isOwn ? 'PERFIL' : '@${user.username ?? ""}'),
        actions: isOwn
            ? [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  tooltip: 'Editar perfil',
                  onPressed: () =>
                      context.push(AppRoutes.editProfile),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, size: 20),
                  tooltip: 'Cerrar sesión',
                  onPressed: () =>
                      ref.read(authRepositoryProvider).signOut(),
                ),
              ]
            : null,
      ),
      body: CustomScrollView(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '@${user.username ?? '...'}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      if (user.isBusiness) ...[
                        const SizedBox(width: BelleSpacing.xs),
                        const VerifiedBadge(size: 16),
                      ],
                    ],
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
                  if (user.isBusiness) _BusinessInfo(user: user),
                  const SizedBox(height: BelleSpacing.lg),
                  _Stats(
                    followers: user.followersCount,
                    following: user.followingCount,
                    clicks: user.totalClicks,
                    onClicksTap: isOwn
                        ? () => context.push(AppRoutes.earnings)
                        : null,
                  ),
                  if (!isOwn) ...[
                    const SizedBox(height: BelleSpacing.lg),
                    FollowButton(targetUid: user.uid),
                  ],
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
                        isOwn
                            ? 'Aún no has publicado outfits'
                            : 'Sin posts publicados',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: BelleSpacing.xs),
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
                      return GestureDetector(
                        onLongPress: isOwn
                            ? () => _confirmDelete(context, post.id)
                            : null,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: CachedNetworkImage(
                            imageUrl: post.mediaUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: BelleColors.ivoryDeep,
                            ),
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
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String postId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: BelleColors.ivory,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BelleRadii.card),
        ),
        title: const Text('Eliminar post'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'ELIMINAR',
              style: TextStyle(color: BelleColors.danger),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    try {
      await ref.read(postRepositoryProvider).deletePost(
            postId: postId,
            userId: user.uid,
          );
      ref.invalidate(feedNotifierProvider);
    } catch (_) {}
  }
}

class _BusinessInfo extends StatelessWidget {
  const _BusinessInfo({required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final hasCategory = user.category?.trim().isNotEmpty ?? false;
    final hasWebsite = user.website?.trim().isNotEmpty ?? false;
    if (!hasCategory && !hasWebsite) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: BelleSpacing.md),
      child: Column(
        children: [
          if (hasCategory)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: BelleSpacing.md,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: BelleColors.rosePaleSoft,
                borderRadius: BorderRadius.circular(BelleRadii.button),
              ),
              child: Text(
                user.category!,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          if (hasWebsite) ...[
            const SizedBox(height: BelleSpacing.sm),
            GestureDetector(
              onTap: () async {
                final uri = Uri.tryParse(user.website!);
                if (uri == null) return;
                await launchUrl(uri,
                    mode: LaunchMode.externalApplication);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.link,
                    size: 16,
                    color: BelleColors.charcoalMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    user.website!.replaceAll(RegExp(r'^https?://'), ''),
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: BelleColors.charcoal,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats({
    required this.followers,
    required this.following,
    required this.clicks,
    this.onClicksTap,
  });

  final int followers;
  final int following;
  final int clicks;
  final VoidCallback? onClicksTap;

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
          onTap: onClicksTap,
          highlighted: onClicksTap != null,
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
