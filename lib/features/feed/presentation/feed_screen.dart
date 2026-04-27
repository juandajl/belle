import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/post_model.dart';
import 'feed_providers.dart';
import 'widgets/tag_dot.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedPostsProvider);

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
            onRefresh: () async => ref.refresh(feedPostsProvider.future),
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
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
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
                  backgroundImage: post.authorPhotoUrl != null
                      ? CachedNetworkImageProvider(post.authorPhotoUrl!)
                      : null,
                  child: post.authorPhotoUrl == null
                      ? const Icon(
                          Icons.person_outline,
                          size: 20,
                          color: BelleColors.charcoalMuted,
                        )
                      : null,
                ),
                const SizedBox(width: BelleSpacing.sm),
                Text(
                  '@${post.authorUsername ?? "usuario"}',
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
                        imageUrl: post.mediaUrl,
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
                      ...post.items.map(
                        (item) => Positioned(
                          left: item.x * w - 13,
                          top: item.y * h - 13,
                          child: TagDot(
                            onTap: () => _showItemSheet(context, item),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: BelleSpacing.sm),
          Row(
            children: [
              const Icon(Icons.favorite_outline, size: 22),
              const SizedBox(width: BelleSpacing.md),
              const Icon(Icons.chat_bubble_outline, size: 22),
              const Spacer(),
              if (post.items.isNotEmpty)
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
                    '${post.items.length} prendas',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              const SizedBox(width: BelleSpacing.sm),
              const Icon(Icons.bookmark_outline, size: 22),
            ],
          ),
          if (post.likesCount > 0) ...[
            const SizedBox(height: 6),
            Text(
              '${post.likesCount} me gusta',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
          if (post.caption != null) ...[
            const SizedBox(height: 6),
            Text(
              post.caption!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }

  void _showItemSheet(BuildContext context, PostItem item) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: BelleColors.ivory,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(BelleRadii.card),
          ),
        ),
        padding: const EdgeInsets.all(BelleSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: BelleColors.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: BelleSpacing.md),
            if (item.brand?.trim().isNotEmpty ?? false)
              Text(
                item.brand!.toUpperCase(),
                style: Theme.of(context).textTheme.labelMedium,
              ),
            const SizedBox(height: 4),
            Text(
              item.name?.trim().isNotEmpty ?? false
                  ? item.name!
                  : 'Prenda etiquetada',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (item.price != null) ...[
              const SizedBox(height: 4),
              Text(
                '${item.currency} ${item.price!.toStringAsFixed(0)}',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  color: BelleColors.charcoal,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const SizedBox(height: BelleSpacing.lg),
            if (item.shopUrl?.trim().isNotEmpty ?? false)
              FilledButton(
                onPressed: () {},
                child: const Text('VER EN TIENDA'),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: BelleSpacing.md,
                  vertical: BelleSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: BelleColors.ivoryDeep,
                  borderRadius: BorderRadius.circular(BelleRadii.small),
                ),
                child: Center(
                  child: Text(
                    'Sin enlace de tienda',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: BelleColors.charcoalMuted,
                    ),
                  ),
                ),
              ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
          ],
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
