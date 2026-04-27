import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/presentation/auth_providers.dart';

// Placeholder. Fase 2 reemplaza esto con el feed real + bottom navigation.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: BelleColors.ivory,
      appBar: AppBar(
        title: const Text('BELLE'),
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
          if (user == null) {
            return const Center(child: Text('Sin sesión'));
          }
          return Padding(
            padding: const EdgeInsets.all(BelleSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    radius: 48,
                    backgroundColor: BelleColors.rosePaleSoft,
                    backgroundImage: user.photoUrl != null
                        ? NetworkImage(user.photoUrl!)
                        : null,
                    child: user.photoUrl == null
                        ? const Icon(
                            Icons.person_outline,
                            size: 44,
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
                const SizedBox(height: BelleSpacing.xl),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: BelleSpacing.lg,
                    vertical: BelleSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: BelleColors.rosePaleSoft,
                    borderRadius: BorderRadius.circular(BelleRadii.card),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'PRÓXIMAMENTE',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: BelleSpacing.xs),
                      Text(
                        'Tu feed de outfits',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: BelleColors.charcoalMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
