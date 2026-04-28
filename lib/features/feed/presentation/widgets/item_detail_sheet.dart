import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/auth_providers.dart';
import '../../../referrals/presentation/referral_providers.dart';
import '../../domain/post_model.dart';

/// Bottom sheet con el detalle de una prenda etiquetada.
/// "VER EN TIENDA" registra el click como referido (si no es propio post)
/// y abre la URL externa en el navegador.
class ItemDetailSheet extends ConsumerWidget {
  const ItemDetailSheet({
    super.key,
    required this.post,
    required this.item,
  });

  final PostModel post;
  final PostItem item;

  Future<void> _onShopTap(BuildContext context, WidgetRef ref) async {
    final url = item.shopUrl;
    if (url == null || url.trim().isEmpty) return;

    final user = ref.read(authStateProvider).valueOrNull;

    // Track click si no es propio post.
    if (user != null && post.userId != user.uid) {
      // Fire and forget — no bloqueamos la apertura del link.
      ref.read(referralRepositoryProvider).trackClick(
            referrerUserId: post.userId,
            clickedByUserId: user.uid,
            postId: post.id,
            item: item,
          );
    }

    final uri = Uri.tryParse(url);
    if (uri == null) return;

    if (!context.mounted) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No pudimos abrir el enlace.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
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
            const SizedBox(height: 6),
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
            FilledButton.icon(
              onPressed: () => _onShopTap(context, ref),
              icon: const Icon(Icons.shopping_bag_outlined, size: 18),
              label: const Text('VER EN TIENDA'),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: BelleSpacing.md,
                vertical: BelleSpacing.md,
              ),
              decoration: BoxDecoration(
                color: BelleColors.ivoryDeep,
                borderRadius: BorderRadius.circular(BelleRadii.button),
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
    );
  }
}
