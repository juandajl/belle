import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Tokens de marca Belle. Centralizados aquí para que toda la UI los consuma
// sin hardcodear hex codes ni TextStyles ad-hoc. Si la marca cambia, este
// archivo es el único que se toca.

class BelleColors {
  static const charcoal = Color(0xFF1A1A1A);
  static const rosePale = Color(0xFFF4C2C2);
  static const gold = Color(0xFFD4AF37);
  static const ivory = Color(0xFFFAFAFA);

  // Derivados para jerarquía sin perder identidad.
  static const charcoalSoft = Color(0xFF2D2D2D);
  static const charcoalMuted = Color(0xFF6B6B6B);
  static const charcoalSubtle = Color(0xFF9A9A9A);
  static const ivoryDeep = Color(0xFFF1EFEC);
  static const rosePaleSoft = Color(0xFFFCEBEB);
  static const goldSoft = Color(0xFFE8D27A);
  static const outline = Color(0xFFE5E2DD);
  static const danger = Color(0xFFB23B3B);
}

class BelleRadii {
  static const button = 32.0;
  static const input = 28.0;
  static const card = 24.0;
  static const small = 14.0;
}

class BelleSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}

class AppTheme {
  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: BelleColors.charcoal,
      onPrimary: BelleColors.ivory,
      secondary: BelleColors.gold,
      onSecondary: BelleColors.charcoal,
      tertiary: BelleColors.rosePale,
      onTertiary: BelleColors.charcoal,
      error: BelleColors.danger,
      onError: BelleColors.ivory,
      surface: BelleColors.ivory,
      onSurface: BelleColors.charcoal,
      surfaceContainerHighest: BelleColors.ivoryDeep,
      onSurfaceVariant: BelleColors.charcoalMuted,
      outline: BelleColors.outline,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: BelleColors.ivory,
    );

    final montserrat = GoogleFonts.montserrat;
    final inter = GoogleFonts.inter;

    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge: montserrat(
          fontSize: 56,
          fontWeight: FontWeight.w300,
          letterSpacing: 8,
          height: 1.05,
          color: BelleColors.charcoal,
        ),
        displayMedium: montserrat(
          fontSize: 44,
          fontWeight: FontWeight.w300,
          letterSpacing: 6,
          height: 1.1,
          color: BelleColors.charcoal,
        ),
        displaySmall: montserrat(
          fontSize: 32,
          fontWeight: FontWeight.w400,
          letterSpacing: 4,
          color: BelleColors.charcoal,
        ),
        headlineLarge: montserrat(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: BelleColors.charcoal,
        ),
        headlineMedium: montserrat(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          color: BelleColors.charcoal,
        ),
        headlineSmall: montserrat(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          color: BelleColors.charcoal,
        ),
        titleLarge: montserrat(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: BelleColors.charcoal,
        ),
        titleMedium: montserrat(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: BelleColors.charcoal,
        ),
        labelLarge: montserrat(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
          color: BelleColors.charcoal,
        ),
        labelMedium: montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
          color: BelleColors.charcoalMuted,
        ),
        bodyLarge: inter(
          fontSize: 16,
          height: 1.45,
          color: BelleColors.charcoal,
        ),
        bodyMedium: inter(
          fontSize: 14,
          height: 1.5,
          color: BelleColors.charcoal,
        ),
        bodySmall: inter(
          fontSize: 12,
          height: 1.45,
          color: BelleColors.charcoalMuted,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: BelleColors.ivory,
        foregroundColor: BelleColors.charcoal,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 3,
          color: BelleColors.charcoal,
        ),
        iconTheme: const IconThemeData(
          color: BelleColors.charcoal,
          size: 22,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return BelleColors.charcoalSubtle;
            }
            return BelleColors.charcoal;
          }),
          foregroundColor: const WidgetStatePropertyAll(BelleColors.ivory),
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(56)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(BelleRadii.button),
            ),
          ),
          textStyle: WidgetStatePropertyAll(
            montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          elevation: const WidgetStatePropertyAll(0),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return BelleColors.ivory.withValues(alpha: 0.12);
            }
            return null;
          }),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: const WidgetStatePropertyAll(BelleColors.charcoal),
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(56)),
          side: const WidgetStatePropertyAll(
            BorderSide(color: BelleColors.charcoal, width: 1.2),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(BelleRadii.button),
            ),
          ),
          textStyle: WidgetStatePropertyAll(
            montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: BelleColors.charcoal,
          textStyle: inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BelleColors.ivoryDeep,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
        prefixIconColor: BelleColors.charcoalMuted,
        suffixIconColor: BelleColors.charcoalMuted,
        hintStyle: inter(
          color: BelleColors.charcoalMuted,
          fontSize: 14,
        ),
        labelStyle: inter(
          color: BelleColors.charcoalMuted,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BelleRadii.input),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BelleRadii.input),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BelleRadii.input),
          borderSide: const BorderSide(color: BelleColors.charcoal, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BelleRadii.input),
          borderSide: const BorderSide(color: BelleColors.danger, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BelleRadii.input),
          borderSide: const BorderSide(color: BelleColors.danger, width: 1.2),
        ),
      ),
      iconTheme: const IconThemeData(
        color: BelleColors.charcoal,
        size: 22,
      ),
      dividerTheme: const DividerThemeData(
        color: BelleColors.outline,
        thickness: 0.5,
        space: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: BelleColors.charcoal,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return BelleColors.ivory;
            }
            return BelleColors.charcoal;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return BelleColors.charcoal;
            }
            return BelleColors.ivory;
          }),
          side: const WidgetStatePropertyAll(
            BorderSide(color: BelleColors.outline),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(BelleRadii.button),
            ),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          ),
          textStyle: WidgetStatePropertyAll(
            montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  static ThemeData dark() {
    // Variante oscura básica. La marca es light-first; la mantenemos para
    // evitar un MediaQuery sin theme cuando el SO esté en modo oscuro.
    return light();
  }
}

/// Wordmark "BELLE" reutilizable. Mantiene proporción y tracking consistentes
/// en splash, login y donde se necesite el logo tipográfico.
class BelleWordmark extends StatelessWidget {
  const BelleWordmark({
    super.key,
    this.fontSize = 44,
    this.color,
  });

  final double fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      'BELLE',
      textAlign: TextAlign.center,
      style: GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: FontWeight.w300,
        letterSpacing: fontSize * 0.18,
        color: color ?? BelleColors.charcoal,
        height: 1,
      ),
    );
  }
}
