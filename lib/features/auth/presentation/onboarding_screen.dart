import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Completa tu perfil')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 16),
                Text(
                  'Cuéntanos un poco sobre ti',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Esto se mostrará en tu perfil público.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    hintText: 'Nombre de usuario',
                    prefixText: '@',
                    prefixIcon: Icon(Icons.alternate_email),
                  ),
                  textInputAction: TextInputAction.next,
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(
                    hintText: 'Bio (opcional)',
                    prefixIcon: Icon(Icons.edit_outlined),
                  ),
                  maxLines: 3,
                  maxLength: 150,
                ),
                const SizedBox(height: 16),
                Text(
                  'Tipo de cuenta',
                  style: theme.textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                SegmentedButton<AccountType>(
                  segments: const [
                    ButtonSegment(
                      value: AccountType.personal,
                      label: Text('Personal'),
                      icon: Icon(Icons.person_outline),
                    ),
                    ButtonSegment(
                      value: AccountType.business,
                      label: Text('Empresa'),
                      icon: Icon(Icons.storefront_outlined),
                    ),
                  ],
                  selected: {_accountType},
                  onSelectionChanged: (set) {
                    setState(() => _accountType = set.first);
                  },
                ),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    style: TextStyle(color: theme.colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Continuar'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _loading
                      ? null
                      : () =>
                          ref.read(authRepositoryProvider).signOut(),
                  child: const Text('Cerrar sesión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
