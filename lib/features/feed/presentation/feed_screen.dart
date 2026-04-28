import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/post_model.dart';
import 'feed_providers.dart';
import 'widgets/item_detail_sheet.dart';
import 'widgets/post_actions.dart';
import 'widgets/tag_dot.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
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

    return Scaffold(
      backgroundColor: BelleColors.ivory,
      appBar: AppBar(
        title: const Text('BELLE'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: BelleSpacing.md),
            child: Icon(Icons.favorite_outline, size: 22),
          ),
        ],
      ),
      body: feedAsync.when(
        loading: () => const _CenteredSpinner(),
        error: (e, _) => _ErrorState(message: '$e'),
        data: (posts) {
          if (posts.isEmpty) return const _EmptyFeed();
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
      ),
    );
  }
}

class _PostCard extends ConsumerWidget {
  const _PostCard({required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usamos el stream del post para reflejar contadores en vivo.
    final liveAsync = ref.watch(postStreamProvider(post.id));
    final live = liveAsync.valueOrNull ?? post;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: BelleSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: BelleSpacing.sm),
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
              const _IconButtonStub(icon: Icons.chat_bubble_outline),
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
}

class _IconButtonStub extends StatelessWidget {
  const _IconButtonStub({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(BelleSpacing.xs),
      child: Icon(icon, size: 22),
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

class _EmptyFeed extends StatelessWidget {
  const _EmptyFeed();

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
              'Aún no hay outfits',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: BelleSpacing.sm),
            Text(
              'Sé la primera en publicar.\nUsa el botón "+" para crear un look.',
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
