import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/presentation/auth_providers.dart';
import '../domain/post_model.dart';
import 'feed_providers.dart';
import 'widgets/comments_sheet.dart';
import 'widgets/item_detail_sheet.dart';
import 'widgets/post_actions.dart';
import 'widgets/tag_dot.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: BelleColors.ivory,
        appBar: AppBar(
          title: const Text('BELLE'),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: _BelleTabBar(),
          ),
        ),
        body: const TabBarView(
          children: [
            _ForYouFeed(),
            _FollowingFeed(),
          ],
        ),
      ),
    );
  }
}

class _BelleTabBar extends StatelessWidget {
  const _BelleTabBar();

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorColor: BelleColors.charcoal,
      indicatorWeight: 1.5,
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: BelleColors.charcoal,
      unselectedLabelColor: BelleColors.charcoalSubtle,
      labelStyle: GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
      ),
      unselectedLabelStyle: GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 2,
      ),
      dividerColor: Colors.transparent,
      tabs: const [
        Tab(text: 'PARA TI'),
        Tab(text: 'SIGUIENDO'),
      ],
    );
  }
}

// --- "Para ti" — feed cronológico paginado ----------------------------

class _ForYouFeed extends ConsumerStatefulWidget {
  const _ForYouFeed();

  @override
  ConsumerState<_ForYouFeed> createState() => _ForYouFeedState();
}

class _ForYouFeedState extends ConsumerState<_ForYouFeed> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final p = _scrollController.position;
    if (p.pixels >= p.maxScrollExtent - 240) {
      ref.read(feedNotifierProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feedAsync = ref.watch(feedNotifierProvider);
    return feedAsync.when(
      loading: () => const _CenteredSpinner(),
      error: (e, _) => _ErrorState(message: '$e'),
      data: (posts) {
        if (posts.isEmpty) {
          return const _EmptyFeed(
            title: 'Aún no hay outfits',
            message: 'Sé la primera en publicar.\nUsa el botón "+" para crear un look.',
          );
        }
        return RefreshIndicator(
          onRefresh: () =>
              ref.read(feedNotifierProvider.notifier).refresh(),
          color: BelleColors.charcoal,
          backgroundColor: BelleColors.ivory,
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: BelleSpacing.md),
            itemCount: posts.length +
                (ref.read(feedNotifierProvider.notifier).hasMore ? 1 : 0),
            separatorBuilder: (_, __) =>
                const SizedBox(height: BelleSpacing.lg),
            itemBuilder: (_, i) {
              if (i >= posts.length) return const _LoadingFooter();
              return _PostCard(post: posts[i]);
            },
          ),
        );
      },
    );
  }
}

// --- "Siguiendo" — solo posts de cuentas seguidas ---------------------

class _FollowingFeed extends ConsumerWidget {
  const _FollowingFeed();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(followingFeedProvider);
    return feedAsync.when(
      loading: () => const _CenteredSpinner(),
      error: (e, _) => _ErrorState(message: '$e'),
      data: (posts) {
        if (posts.isEmpty) {
          return const _EmptyFeed(
            title: 'Sigue a más cuentas',
            message: 'Cuando sigas a alguien, sus outfits aparecen aquí.',
          );
        }
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(followingFeedProvider),
          color: BelleColors.charcoal,
          backgroundColor: BelleColors.ivory,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: BelleSpacing.md),
            itemCount: posts.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: BelleSpacing.lg),
            itemBuilder: (_, i) => _PostCard(post: posts[i]),
          ),
        );
      },
    );
  }
}

// --- Card de un post --------------------------------------------------

class _PostCard extends ConsumerWidget {
  const _PostCard({required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveAsync = ref.watch(postStreamProvider(post.id));
    final live = liveAsync.valueOrNull ?? post;
    final me = ref.watch(authStateProvider).valueOrNull;
    final isOwn = me?.uid == live.userId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: BelleSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: BelleSpacing.sm),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () =>
                      context.push(AppRoutes.userProfile(live.userId)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: BelleColors.rosePaleSoft,
                        backgroundImage: live.authorPhotoUrl != null
                            ? CachedNetworkImageProvider(live.authorPhotoUrl!)
                            : null,
                        child: live.authorPhotoUrl == null
                            ? const Icon(
                                Icons.person_outline,
                                size: 20,
                                color: BelleColors.charcoalMuted,
                              )
                            : null,
                      ),
                      const SizedBox(width: BelleSpacing.sm),
                      Text(
                        '@${live.authorUsername ?? "usuario"}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (isOwn)
                  IconButton(
                    icon: const Icon(Icons.more_horiz, size: 22),
                    onPressed: () => _showOwnPostMenu(context, ref, live),
                  ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(BelleRadii.card),
            child: AspectRatio(
              aspectRatio: 1,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final w = constraints.maxWidth;
                  final h = constraints.maxHeight;
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: live.mediaUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: BelleColors.ivoryDeep,
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: BelleColors.ivoryDeep,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            color: BelleColors.charcoalMuted,
                          ),
                        ),
                      ),
                      ...live.items.map(
                        (item) => Positioned(
                          left: item.x * w - 13,
                          top: item.y * h - 13,
                          child: TagDot(
                            onTap: () => _showItemSheet(context, live, item),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              LikeButton(postId: live.id),
              const SizedBox(width: BelleSpacing.sm),
              GestureDetector(
                onTap: () => _showCommentsSheet(context, live.id),
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.all(BelleSpacing.xs),
                  child: Icon(Icons.chat_bubble_outline, size: 22),
                ),
              ),
              const Spacer(),
              if (live.items.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: BelleSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: BelleColors.rosePaleSoft,
                    borderRadius: BorderRadius.circular(BelleRadii.button),
                  ),
                  child: Text(
                    '${live.items.length} prendas',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              const SizedBox(width: BelleSpacing.xs),
              SaveButton(postId: live.id),
            ],
          ),
          if (live.likesCount > 0) ...[
            const SizedBox(height: 4),
            Text(
              live.likesCount == 1
                  ? '1 me gusta'
                  : '${live.likesCount} me gusta',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
          if (live.caption != null) ...[
            const SizedBox(height: 4),
            Text(
              live.caption!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          if (live.commentsCount > 0) ...[
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () => _showCommentsSheet(context, live.id),
              child: Text(
                live.commentsCount == 1
                    ? 'Ver 1 comentario'
                    : 'Ver ${live.commentsCount} comentarios',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: BelleColors.charcoalMuted,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showItemSheet(
    BuildContext context,
    PostModel post,
    PostItem item,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ItemDetailSheet(post: post, item: item),
    );
  }

  void _showCommentsSheet(BuildContext context, String postId) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CommentsSheet(postId: postId),
    );
  }

  void _showOwnPostMenu(
    BuildContext context,
    WidgetRef ref,
    PostModel post,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: BelleColors.ivory,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(BelleRadii.card),
        ),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(BelleSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:
                    const Icon(Icons.delete_outline, color: BelleColors.danger),
                title: Text(
                  'Eliminar post',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: BelleColors.danger,
                  ),
                ),
                onTap: () async {
                  Navigator.of(sheetCtx).pop();
                  await _confirmDelete(context, ref, post);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    PostModel post,
  ) async {
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
            postId: post.id,
            userId: post.userId,
          );
      ref.invalidate(feedNotifierProvider);
    } catch (_) {}
  }
}

// --- estados auxiliares -----------------------------------------------

class _EmptyFeed extends StatelessWidget {
  const _EmptyFeed({required this.title, required this.message});
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(BelleSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: BelleColors.rosePaleSoft,
                borderRadius: BorderRadius.circular(44),
              ),
              child: const Icon(
                Icons.image_outlined,
                size: 44,
                color: BelleColors.charcoal,
              ),
            ),
            const SizedBox(height: BelleSpacing.lg),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: BelleSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: BelleColors.charcoalMuted,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingFooter extends StatelessWidget {
  const _LoadingFooter();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: BelleSpacing.lg),
      child: Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 1.2),
        ),
      ),
    );
  }
}

class _CenteredSpinner extends StatelessWidget {
  const _CenteredSpinner();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 1.2),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(BelleSpacing.lg),
        child: Text(
          'No pudimos cargar el feed.\n$message',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: BelleColors.charcoalMuted,
          ),
        ),
      ),
    );
  }
}
