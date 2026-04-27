import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/post_model.dart';

/// Bottom sheet para crear o editar la información de una prenda etiquetada.
/// Devuelve el [PostItem] resultante, o `null` si el usuario cancela.
/// Si [onDelete] se provee, muestra un botón de eliminar.
class ItemEditorSheet extends StatefulWidget {
  const ItemEditorSheet({
    super.key,
    required this.item,
    this.onDelete,
  });

  final PostItem item;
  final VoidCallback? onDelete;

  @override
  State<ItemEditorSheet> createState() => _ItemEditorSheetState();
}

class _ItemEditorSheetState extends State<ItemEditorSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _brandController;
  late final TextEditingController _priceController;
  late final TextEditingController _shopUrlController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name ?? '');
    _brandController = TextEditingController(text: widget.item.brand ?? '');
    _priceController = TextEditingController(
      text: widget.item.price != null ? widget.item.price!.toStringAsFixed(0) : '',
    );
    _shopUrlController = TextEditingController(text: widget.item.shopUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _shopUrlController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final priceText = _priceController.text.trim();
    final result = widget.item.copyWith(
      name: _nameController.text.trim().isEmpty
          ? null
          : _nameController.text.trim(),
      brand: _brandController.text.trim().isEmpty
          ? null
          : _brandController.text.trim(),
      price: priceText.isEmpty ? null : double.tryParse(priceText),
      shopUrl: _shopUrlController.text.trim().isEmpty
          ? null
          : _shopUrlController.text.trim(),
    );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: BelleColors.ivory,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(BelleRadii.card),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(
          BelleSpacing.lg,
          BelleSpacing.md,
          BelleSpacing.lg,
          BelleSpacing.lg,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              Text(
                'PRENDA',
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: BelleSpacing.lg),
              _Field(
                controller: _nameController,
                hint: 'Nombre (vestido, blusa, zapatos...)',
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: BelleSpacing.md),
              _Field(
                controller: _brandController,
                hint: 'Marca',
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: BelleSpacing.md),
              _Field(
                controller: _priceController,
                hint: 'Precio aproximado',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return null;
                  if (double.tryParse(value) == null) {
                    return 'Precio no válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: BelleSpacing.md),
              _Field(
                controller: _shopUrlController,
                hint: 'URL de la tienda (https://...)',
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _save(),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return null;
                  final uri = Uri.tryParse(value.trim());
                  if (uri == null || !uri.hasScheme) return 'URL no válida';
                  return null;
                },
              ),
              const SizedBox(height: BelleSpacing.lg),
              FilledButton(
                onPressed: _save,
                child: const Text('GUARDAR'),
              ),
              if (widget.onDelete != null) ...[
                const SizedBox(height: BelleSpacing.sm),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onDelete!();
                  },
                  child: Text(
                    'Eliminar etiqueta',
                    style: GoogleFonts.inter(
                      color: BelleColors.danger,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.inputFormatters,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      inputFormatters: inputFormatters,
      validator: validator,
      style: GoogleFonts.inter(fontSize: 15, color: BelleColors.charcoal),
      decoration: InputDecoration(hintText: hint),
    );
  }
}
