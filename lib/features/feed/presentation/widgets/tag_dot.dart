import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Pequeño marcador circular para indicar una prenda etiquetada en una foto.
class TagDot extends StatelessWidget {
  const TagDot({
    super.key,
    this.size = 26,
    this.onTap,
    this.compact = false,
  });

  final double size;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: BelleColors.ivory.withValues(alpha: 0.96),
        border: Border.all(color: BelleColors.charcoal, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: BelleColors.charcoal.withValues(alpha: 0.18),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: size * 0.32,
          height: size * 0.32,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: BelleColors.charcoal,
          ),
        ),
      ),
    );

    if (onTap == null) return dot;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: compact ? dot : Padding(padding: const EdgeInsets.all(8), child: dot),
    );
  }
}
