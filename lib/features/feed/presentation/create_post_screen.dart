import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/presentation/auth_providers.dart';
import '../domain/post_model.dart';
import 'feed_providers.dart';
import 'widgets/item_editor_sheet.dart';
import 'widgets/tag_dot.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _picker = ImagePicker();
  final _captionController = TextEditingController();

  File? _imageFile;
  final List<PostItem> _items = [];
  bool _publishing = false;
  String? _error;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1440,
    );
    if (picked == null) return;
    setState(() {
      _imageFile = File(picked.path);
      _items.clear();
    });
  }

  Future<void> _showImageSourceSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: BelleColors.ivory,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(BelleRadii.card),
        ),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(BelleSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: Text(
                    'Galería',
                    style: GoogleFonts.inter(fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.of(sheetCtx).pop();
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: Text(
                    'Cámara',
                    style: GoogleFonts.inter(fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.of(sheetCtx).pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _addTagAt(double normalizedX, double normalizedY) async {
    final newId = DateTime.now().microsecondsSinceEpoch.toString();
    final draft = PostItem(id: newId, x: normalizedX, y: normalizedY);

    final result = await showModalBottomSheet<PostItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ItemEditorSheet(item: draft),
    );

    if (result != null) {
      setState(() => _items.add(result));
    }
  }

  Future<void> _editTag(PostItem item) async {
    final result = await showModalBottomSheet<PostItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ItemEditorSheet(
        item: item,
        onDelete: () {
          setState(() => _items.removeWhere((i) => i.id == item.id));
        },
      ),
    );

    if (result != null) {
      setState(() {
        final idx = _items.indexWhere((i) => i.id == item.id);
        if (idx != -1) _items[idx] = result;
      });
    }
  }

  Future<void> _publish() async {
    if (_imageFile == null) {
      setState(() => _error = 'Elige una foto primero');
      return;
    }

    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) {
      setState(() => _error = 'Sesión expirada');
      return;
    }

    setState(() {
      _publishing = true;
      _error = null;
    });

    try {
      await ref.read(postRepositoryProvider).createPost(
            userId: user.uid,
            authorUsername: user.username,
            authorPhotoUrl: user.photoUrl,
            imageFile: _imageFile!,
            caption: _captionController.text,
            items: _items,
          );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      setState(() => _error = 'Error publicando: $e');
    } finally {
      if (mounted) setState(() => _publishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BelleColors.ivory,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, size: 22),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('NUEVO POST'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: BelleSpacing.md),
            child: TextButton(
              onPressed: (_publishing || _imageFile == null) ? null : _publish,
              child: Text(
                _publishing ? '...' : 'PUBLICAR',
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: (_publishing || _imageFile == null)
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
          if (_imageFile == null)
            _ImagePicker(onTap: _showImageSourceSheet)
          else
            _TaggablePhoto(
              imageFile: _imageFile!,
              items: _items,
              onTapEmpty: _addTagAt,
              onTapTag: _editTag,
            ),
          const SizedBox(height: BelleSpacing.md),
          if (_imageFile != null)
            Center(
              child: TextButton.icon(
                onPressed: _showImageSourceSheet,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Cambiar foto'),
              ),
            ),
          const SizedBox(height: BelleSpacing.md),
          if (_imageFile != null && _items.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: BelleSpacing.md,
                vertical: BelleSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: BelleColors.rosePaleSoft,
                borderRadius: BorderRadius.circular(BelleRadii.small),
              ),
              child: Text(
                'Toca la foto para etiquetar prendas',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: BelleColors.charcoalSoft,
                ),
              ),
            ),
          if (_items.isNotEmpty) ...[
            const SizedBox(height: BelleSpacing.md),
            _ItemsSummary(items: _items, onTap: _editTag),
          ],
          const SizedBox(height: BelleSpacing.lg),
          TextField(
            controller: _captionController,
            maxLines: 4,
            maxLength: 500,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: BelleColors.charcoal,
            ),
            decoration: const InputDecoration(
              hintText: 'Caption · usa #hashtags...',
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

class _ImagePicker extends StatelessWidget {
  const _ImagePicker({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: BelleColors.ivoryDeep,
            borderRadius: BorderRadius.circular(BelleRadii.card),
            border: Border.all(
              color: BelleColors.outline,
              width: 1,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_photo_alternate_outlined,
                size: 48,
                color: BelleColors.charcoalMuted,
              ),
              const SizedBox(height: BelleSpacing.sm),
              Text(
                'AGREGAR FOTO',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaggablePhoto extends StatelessWidget {
  const _TaggablePhoto({
    required this.imageFile,
    required this.items,
    required this.onTapEmpty,
    required this.onTapTag,
  });

  final File imageFile;
  final List<PostItem> items;
  final void Function(double x, double y) onTapEmpty;
  final void Function(PostItem item) onTapTag;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(BelleRadii.card),
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            return GestureDetector(
              onTapUp: (details) {
                final x = (details.localPosition.dx / w).clamp(0.0, 1.0);
                final y = (details.localPosition.dy / h).clamp(0.0, 1.0);
                onTapEmpty(x, y);
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(imageFile, fit: BoxFit.cover),
                  ...items.map((item) => Positioned(
                        left: item.x * w - 13,
                        top: item.y * h - 13,
                        child: TagDot(onTap: () => onTapTag(item)),
                      )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ItemsSummary extends StatelessWidget {
  const _ItemsSummary({required this.items, required this.onTap});

  final List<PostItem> items;
  final void Function(PostItem) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            '${items.length} ${items.length == 1 ? "PRENDA" : "PRENDAS"} ETIQUETADAS',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        ...items.map(
          (item) => InkWell(
            onTap: () => onTap(item),
            borderRadius: BorderRadius.circular(BelleRadii.small),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: BelleSpacing.md,
                vertical: BelleSpacing.sm,
              ),
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: BelleColors.ivoryDeep,
                borderRadius: BorderRadius.circular(BelleRadii.small),
              ),
              child: Row(
                children: [
                  const TagDot(size: 22, compact: true),
                  const SizedBox(width: BelleSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.name?.trim().isNotEmpty ?? false
                              ? item.name!
                              : 'Sin nombre',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (item.brand?.trim().isNotEmpty ?? false)
                          Text(
                            item.brand!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                  if (item.price != null)
                    Text(
                      '${item.currency} ${item.price!.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  const SizedBox(width: BelleSpacing.sm),
                  const Icon(Icons.chevron_right, size: 18),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
