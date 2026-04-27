import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../data/auth_repository.dart';
import 'auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSignUp = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(authRepositoryProvider);
      if (_isSignUp) {
        await repo.signUpWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        await repo.signInWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
        );
      }
    } on AuthException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
    } on AuthException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BelleColors.ivory,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: BelleSpacing.lg),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 64),
                const BelleWordmark(fontSize: 44),
                const SizedBox(height: BelleSpacing.sm),
                Text(
                  _isSignUp
                      ? 'Comienza tu historia'
                      : 'Bienvenida de vuelta',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: BelleColors.charcoalMuted,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: BelleSpacing.xxl),
                _BelleTextField(
                  controller: _emailController,
                  hint: 'Correo electrónico',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa tu correo';
                    }
                    if (!value.contains('@')) return 'Correo no válido';
                    return null;
                  },
                ),
                const SizedBox(height: BelleSpacing.md),
                _BelleTextField(
                  controller: _passwordController,
                  hint: 'Contraseña',
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu contraseña';
                    }
                    if (_isSignUp && value.length < 6) {
                      return 'Mínimo 6 caracteres';
                    }
                    return null;
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
                const SizedBox(height: BelleSpacing.lg),
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
                      : Text(_isSignUp ? 'CREAR CUENTA' : 'INGRESAR'),
                ),
                const SizedBox(height: BelleSpacing.lg),
                const _OrDivider(),
                const SizedBox(height: BelleSpacing.lg),
                OutlinedButton.icon(
                  onPressed: _loading ? null : _signInWithGoogle,
                  icon: const _GoogleGlyph(),
                  label: const Text('CONTINUAR CON GOOGLE'),
                ),
                const SizedBox(height: BelleSpacing.xl),
                Center(
                  child: TextButton(
                    onPressed: _loading
                        ? null
                        : () => setState(() {
                              _isSignUp = !_isSignUp;
                              _error = null;
                            }),
                    child: Text.rich(
                      TextSpan(
                        text: _isSignUp
                            ? '¿Ya tienes cuenta?  '
                            : '¿Eres nueva?  ',
                        style: GoogleFonts.inter(
                          color: BelleColors.charcoalMuted,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: _isSignUp ? 'Ingresa' : 'Crea tu cuenta',
                            style: GoogleFonts.inter(
                              color: BelleColors.charcoal,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BelleTextField extends StatelessWidget {
  const _BelleTextField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.onSubmitted,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      style: GoogleFonts.inter(
        fontSize: 15,
        color: BelleColors.charcoal,
      ),
      decoration: InputDecoration(hintText: hint),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: BelleSpacing.md),
          child: Text(
            'O',
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 3,
              color: BelleColors.charcoalSubtle,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _GoogleGlyph extends StatelessWidget {
  const _GoogleGlyph();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: BelleColors.ivory,
      ),
      child: Text(
        'G',
        style: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: BelleColors.charcoal,
          height: 1,
        ),
      ),
    );
  }
}
