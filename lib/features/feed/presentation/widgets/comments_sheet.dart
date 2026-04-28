import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/auth_providers.dart';
import '../../../profile/presentation/profile_providers.dart';

class CommentsSheet extends ConsumerStatefulWidget {
  const CommentsSheet({super.key, required this.postId});

  final String postId;

  @override
  ConsumerState<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends ConsumerState<CommentsSheet> {
  final _controller = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return;

    setState(() => _sending = true);
    try {
      await ref.read(commentRepositoryProvider).addComment(
            postId: widget.postId,
            author: user,
            text: text,
          );
      _controller.clear();
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(postCommentsProvider(widget.postId));
    final viewInsets = MediaQuery.of(context).viewInsets;

    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: BelleColors.ivory,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(BelleRadii.card),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: BelleSpacing.sm),
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
            const SizedBox(height: BelleSpacing.sm),
            Text(
              'COMENTARIOS',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: BelleSpacing.sm),
            const Divider(height: 1),
            Expanded(
              child: commentsAsync.when(
                loading: () => const Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 1.2),
                  ),
                ),
                error: (e, _) => Center(
                  child: Text(
                    'Error: $e',
                    style: GoogleFonts.inter(
                      color: BelleColors.charcoalMuted,
                    ),
                  ),
                ),
                data: (comments) {
                  if (comments.isEmpty) {
                    return Center(
                      child: Text(
                        'Sé la primera en comentar.',
                        style: GoogleFonts.inter(
                          color: BelleColors.charcoalMuted,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: BelleSpacing.lg,
                      vertical: BelleSpacing.md,
                    ),
                    itemCount: comments.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: BelleSpacing.md),
                    itemBuilder: (_, i) {
                      final c = comments[i];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: BelleColors.rosePaleSoft,
                            backgroundImage: c.userPhotoUrl != null
                                ? CachedNetworkImageProvider(c.userPhotoUrl!)
                                : null,
                            child: c.userPhotoUrl == null
                                ? const Icon(
                                    Icons.person_outline,
                                    size: 18,
                                    color: BelleColors.charcoalMuted,
                                  )
                                : null,
                          ),
                          const SizedBox(width: BelleSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '@${c.username ?? "usuario"}',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  c.text,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                BelleSpacing.lg,
                BelleSpacing.sm,
                BelleSpacing.sm,
                BelleSpacing.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: BelleColors.charcoal,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Comenta algo...',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _sending ? null : _send,
                    icon: const Icon(Icons.send, size: 22),
                    color: BelleColors.charcoal,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
