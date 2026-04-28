import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/presentation/auth_providers.dart';
import '../domain/referral_model.dart';
import 'referral_providers.dart';

class EarningsScreen extends ConsumerWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).valueOrNull;
    if (user == null) return const Scaffold(body: Center(child: Text('—')));

    final referralsAsync = ref.watch(userReferralsProvider(user.uid));

    return Scaffold(
      backgroundColor: BelleColors.ivory,
      appBar: AppBar(
        title: const Text('GANANCIAS'),
      ),
      body: referralsAsync.when(
        loading: () => const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 1.2),
          ),
        ),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(BelleSpacing.lg),
            child: Text(
              'Error: $e',
              style: GoogleFonts.inter(color: BelleColors.charcoalMuted),
            ),
          ),
        ),
        data: (referrals) {
          final clicks = referrals.length;
          final conversions = referrals.where((r) => r.converted).length;
          final earnings = referrals.fold<double>(0, (s, r) => s + r.earnings);

          return ListView(
            padding: const EdgeInsets.all(BelleSpacing.lg),
            children: [
              _BigStatCard(earnings: earnings),
              const SizedBox(height: BelleSpacing.md),
              Row(
                children: [
                  Expanded(child: _SmallStat(value: '$clicks', label: 'CLICKS')),
                  const SizedBox(width: BelleSpacing.sm),
                  Expanded(
                    child: _SmallStat(
                      value: '$conversions',
                      label: 'CONVERSIONES',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: BelleSpacing.lg),
              if (referrals.isEmpty)
                _EmptyState()
              else ...[
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    'CLICKS RECIENTES',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                ...referrals.map((r) => _ReferralRow(referral: r)),
              ],
              const SizedBox(height: BelleSpacing.lg),
              Container(
                padding: const EdgeInsets.all(BelleSpacing.md),
                decoration: BoxDecoration(
                  color: BelleColors.rosePaleSoft,
                  borderRadius: BorderRadius.circular(BelleRadii.card),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 20,
                      color: BelleColors.charcoal,
                    ),
                    const SizedBox(width: BelleSpacing.sm),
                    Expanded(
                      child: Text(
                        'Las ganancias se confirman cuando la marca valida la compra. '
                        'Por ahora ves los clicks; los retiros se habilitan en una próxima fase.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: BelleColors.charcoalSoft,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BigStatCard extends StatelessWidget {
  const _BigStatCard({required this.earnings});
  final double earnings;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: BelleSpacing.lg,
        vertical: BelleSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: BelleColors.charcoal,
        borderRadius: BorderRadius.circular(BelleRadii.card),
      ),
      child: Column(
        children: [
          Text(
            'TOTAL ACUMULADO',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: BelleColors.ivory.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: BelleSpacing.sm),
          Text(
            '\$${earnings.toStringAsFixed(2)}',
            style: GoogleFonts.montserrat(
              fontSize: 44,
              fontWeight: FontWeight.w300,
              letterSpacing: 1,
              color: BelleColors.ivory,
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallStat extends StatelessWidget {
  const _SmallStat({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: BelleSpacing.md,
        vertical: BelleSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: BelleColors.ivoryDeep,
        borderRadius: BorderRadius.circular(BelleRadii.card),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: BelleSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}

class _ReferralRow extends StatelessWidget {
  const _ReferralRow({required this.referral});
  final ReferralModel referral;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: BelleSpacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: BelleSpacing.md,
        vertical: BelleSpacing.md,
      ),
      decoration: BoxDecoration(
        color: BelleColors.ivoryDeep,
        borderRadius: BorderRadius.circular(BelleRadii.small),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  referral.itemBrand?.toUpperCase() ?? 'PRENDA',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  referral.itemName ?? 'Sin nombre',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          if (referral.itemPrice != null)
            Text(
              '${referral.itemCurrency ?? "USD"} ${referral.itemPrice!.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          const SizedBox(width: BelleSpacing.sm),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: referral.converted
                  ? BelleColors.gold
                  : BelleColors.charcoalSubtle,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: BelleSpacing.xxl),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: BelleColors.rosePaleSoft,
                borderRadius: BorderRadius.circular(36),
              ),
              child: const Icon(
                Icons.bar_chart_rounded,
                size: 36,
                color: BelleColors.charcoal,
              ),
            ),
            const SizedBox(height: BelleSpacing.md),
            Text(
              'Aún sin clicks',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: BelleSpacing.sm),
            Text(
              'Cuando alguien toque "Ver en tienda" en\nuna prenda etiquetada por ti, aparecerá aquí.',
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
