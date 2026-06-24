import 'package:flutter/material.dart';

import '../flext_palette.dart';

/// Temas padrão do painel admin do Flext — claro e escuro, derivados da paleta
/// central [FlextPalette] (mesma identidade do site). Bonito por padrão:
///
/// ```dart
/// MaterialApp(
///   theme: FlextAdminTheme.light(),
///   darkTheme: FlextAdminTheme.dark(),
///   themeMode: ThemeMode.system,
/// )
/// ```
class FlextAdminTheme {
  const FlextAdminTheme._();

  static final Color brand = Color(FlextPalette.argb(FlextPalette.primary));

  static ThemeData light({Color? seed}) => _build(
        scheme: ColorScheme.fromSeed(seedColor: seed ?? brand).copyWith(
          surface: Colors.white,
          outlineVariant: Color(FlextPalette.argb(FlextPalette.border)),
          onSurface: Color(FlextPalette.argb(FlextPalette.ink)),
        ),
        scaffold: const Color(0xFFF6F8FB),
      );

  static ThemeData dark({Color? seed}) => _build(
        scheme: ColorScheme.fromSeed(
          seedColor: seed ?? brand,
          brightness: Brightness.dark,
        ).copyWith(
          surface: Color(FlextPalette.argb(FlextPalette.darkSurface)),
          outlineVariant: Color(FlextPalette.argb(FlextPalette.darkBorder)),
          onSurface: Color(FlextPalette.argb(FlextPalette.darkInk)),
        ),
        scaffold: Color(FlextPalette.argb(FlextPalette.darkBg)),
      );

  static ThemeData _build({required ColorScheme scheme, required Color scaffold}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      fontFamily: 'system-ui',
      dividerTheme:
          DividerThemeData(color: scheme.outlineVariant, space: 1, thickness: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        shape: Border(bottom: BorderSide(color: scheme.outlineVariant)),
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surface,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
