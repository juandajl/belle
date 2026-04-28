import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/services/storage_service.dart';
import '../../../shared/widgets/verified_badge.dart';
import '../../auth/presentation/auth_providers.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _displayNameController;
  late final TextEditingController _bioController;
  late final TextEditingController _websiteController;
  String? _category;
  final _picker = ImagePicker();
  final _storage = StorageService();

  File? _newAvatarFile;
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
    _websiteController = TextEditingController(text: user?.website ?? '');
    _category = user?.category;
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: BelleColors.ivory,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(BelleRadii.card),
        ),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(BelleSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text('Galería',
                    style: GoogleFonts.inter(fontSize: 15)),
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  _pick(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text('Cámara',
                    style: GoogleFonts.inter(fontSize: 15)),
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  _pick(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pick(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 720,
    );
    if (picked == null) return;
    setState(() => _newAvatarFile = File(picked.path));
  }

  Future<void> _save() async {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      String? newPhotoUrl;
      if (_newAvatarFile != null) {
        newPhotoUrl = await _storage.uploadAvatar(
          userId: user.uid,
          file: _newAvatarFile!,
        );
      }
      await ref.read(authRepositoryProvider).updateProfile(
            uid: user.uid,
            displayName: _displayNameController.text,
            bio: _bioController.text,
            photoUrl: newPhotoUrl,
            website: user.isBusiness ? _websiteController.text : null,
            category: user.isBusiness ? _category : null,
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
    final user = ref.watch(currentUserProvider).valueOrNull;
    final isBusiness = user?.isBusiness ?? false;

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
          Center(
            child: GestureDetector(
              onTap: _pickAvatar,
              child: Stack(
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
                      backgroundImage: _newAvatarFile != null
                          ? FileImage(_newAvatarFile!) as ImageProvider
                          : (user?.photoUrl != null
                              ? CachedNetworkImageProvider(user!.photoUrl!)
                              : null),
                      child: _newAvatarFile == null && user?.photoUrl == null
                          ? const Icon(
                              Icons.person_outline,
                              size: 44,
                              color: BelleColors.charcoalMuted,
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: BelleColors.charcoal,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: BelleColors.ivory,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        size: 16,
                        color: BelleColors.ivory,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: BelleSpacing.sm),
          Center(
            child: TextButton(
              onPressed: _pickAvatar,
              child: const Text('Cambiar foto'),
            ),
          ),
          const SizedBox(height: BelleSpacing.lg),
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              isBusiness ? 'NOMBRE DE LA MARCA' : 'NOMBRE',
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
              isBusiness ? 'DESCRIPCIÓN DE LA MARCA' : 'BIO',
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
          if (isBusiness) ...[
            const SizedBox(height: BelleSpacing.lg),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 6),
              child: Text(
                'SITIO WEB',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            TextField(
              controller: _websiteController,
              keyboardType: TextInputType.url,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: BelleColors.charcoal,
              ),
              decoration: const InputDecoration(
                hintText: 'https://...',
                prefixIcon: Icon(Icons.link, size: 20),
              ),
            ),
            const SizedBox(height: BelleSpacing.lg),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 6),
              child: Text(
                'CATEGORÍA',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            DropdownButtonFormField<String>(
              initialValue: _category,
              items: BusinessCategories.all
                  .map((c) =>
                      DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v),
              style: GoogleFonts.inter(
                fontSize: 15,
                color: BelleColors.charcoal,
              ),
              decoration: const InputDecoration(
                hintText: 'Categoría',
                prefixIcon: Icon(Icons.label_outline, size: 20),
              ),
            ),
          ],
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
