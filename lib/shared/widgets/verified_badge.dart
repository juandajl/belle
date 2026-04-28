import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Badge dorado tipo "verificado" que se muestra junto al username de
/// cuentas tipo Empresa.
class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({super.key, this.size = 14});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: BelleColors.gold,
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.check,
        size: size * 0.65,
        color: BelleColors.charcoal,
      ),
    );
  }
}

/// Lista de categorías predefinidas para cuentas tipo Empresa.
class BusinessCategories {
  static const all = <String>[
    'Ropa femenina',
    'Ropa masculina',
    'Calzado',
    'Accesorios',
    'Joyería',
    'Bolsos',
    'Lujo',
    'Streetwear',
    'Sostenible',
    'Belleza',
    'Otro',
  ];
}
