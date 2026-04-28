import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/presentation/auth_providers.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _displayNameController;
  late final TextEditingController _bioController;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider).valueOrNull;
    _displayNameController = TextEditingController(
      text: user?.displayName ?? '',
    );
    _bioController = TextEditingController(text: user?.bio ?? '');
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(authRepositoryProvider).updateProfile(
            uid: user.uid,
            displayName: _displayNameController.text,
            bio: _bioController.text,
          );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() => _error = 'Error guardando: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BelleColors.ivory,
      appBar: AppBar(
        title: const Text('EDITAR PERFIL'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: BelleSpacing.md),
            child: TextButton(
              onPressed: _saving ? null : _save,
              child: Text(
                _saving ? '...' : 'GUARDAR',
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: _saving
                      ? BelleColors.charcoalSubtle
                      : BelleColors.charcoal,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(BelleSpacing.lg),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              'NOMBRE',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          TextField(
            controller: _displayNameController,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: BelleColors.charcoal,
            ),
            decoration: const InputDecoration(
              hintText: 'Tu nombre público',
            ),
          ),
          const SizedBox(height: BelleSpacing.lg),
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              'BIO',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          TextField(
            controller: _bioController,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: BelleColors.charcoal,
            ),
            maxLines: 4,
            maxLength: 150,
            decoration: const InputDecoration(
              hintText: 'Cuéntanos sobre ti',
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: BelleSpacing.md),
            Text(
              _error!,
              style: const TextStyle(color: BelleColors.danger),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
