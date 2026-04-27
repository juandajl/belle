import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/user_model.dart';
import 'auth_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  AccountType _accountType = AccountType.personal;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    final repo = ref.read(authRepositoryProvider);
    final uid = repo.currentUser?.uid;
    if (uid == null) {
      setState(() {
        _error = 'Sesión expirada.';
        _loading = false;
      });
      return;
    }

    try {
      final available =
          await repo.isUsernameAvailable(_usernameController.text);
      if (!available) {
        setState(() {
          _error = 'Ese username ya está en uso.';
          _loading = false;
        });
        return;
      }
      await repo.completeOnboarding(
        uid: uid,
        username: _usernameController.text,
        type: _accountType,
        bio: _bioController.text.isEmpty ? null : _bioController.text,
      );
    } catch (e) {
      setState(() => _error = 'Error guardando perfil: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BelleColors.ivory,
      appBar: AppBar(
        title: const Text('PERFIL'),
        leading: IconButton(
          icon: const Icon(Icons.close, size: 22),
          onPressed: () => ref.read(authRepositoryProvider).signOut(),
          tooltip: 'Cerrar sesión',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: BelleSpacing.lg),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: BelleSpacing.md),
                Text(
                  'Cuéntanos sobre ti',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: BelleSpacing.sm),
                Text(
                  'Esto se mostrará en tu perfil público.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: BelleColors.charcoalMuted,
                  ),
                ),
                const SizedBox(height: BelleSpacing.xl),
                TextFormField(
                  controller: _usernameController,
                  textInputAction: TextInputAction.next,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: BelleColors.charcoal,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Nombre de usuario',
                    prefixText: '@  ',
                  ),
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return 'Elige un username';
                    if (v.length < 3) return 'Mínimo 3 caracteres';
                    if (!RegExp(r'^[a-zA-Z0-9_.]+$').hasMatch(v)) {
                      return 'Solo letras, números, "_" y "."';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: BelleSpacing.md),
                TextFormField(
                  controller: _bioController,
                  maxLines: 3,
                  maxLength: 150,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: BelleColors.charcoal,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Bio (opcional)',
                  ),
                ),
                const SizedBox(height: BelleSpacing.md),
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 10),
                  child: Text(
                    'TIPO DE CUENTA',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                SegmentedButton<AccountType>(
                  segments: const [
                    ButtonSegment(
                      value: AccountType.personal,
                      label: Text('PERSONAL'),
                    ),
                    ButtonSegment(
                      value: AccountType.business,
                      label: Text('EMPRESA'),
                    ),
                  ],
                  selected: {_accountType},
                  showSelectedIcon: false,
                  onSelectionChanged: (set) {
                    setState(() => _accountType = set.first);
                  },
                ),
                if (_error != null) ...[
                  const SizedBox(height: BelleSpacing.md),
                  Text(
                    _error!,
                    style: const TextStyle(color: BelleColors.danger),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: BelleSpacing.xl),
                FilledButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: BelleColors.ivory,
                          ),
                        )
                      : const Text('CONTINUAR'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
