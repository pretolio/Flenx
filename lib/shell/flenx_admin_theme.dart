import 'package:flutter/material.dart';

import '../flenx_palette.dart';

/// Temas padrão do painel admin do Flenx — claro e escuro, derivados da paleta
/// central [FlenxPalette] (mesma identidade do site). Bonito por padrão:
///
/// ```dart
/// MaterialApp(
///   theme: FlenxAdminTheme.light(),
///   darkTheme: FlenxAdminTheme.dark(),
///   themeMode: ThemeMode.system,
/// )
/// ```
class FlenxAdminTheme {
  const FlenxAdminTheme._();

  static final Color brand = Color(FlenxPalette.argb(FlenxPalette.primary));

  static ThemeData light({Color? seed}) => _build(
        scheme: ColorScheme.fromSeed(seedColor: seed ?? brand).copyWith(
          surface: Colors.white,
          outlineVariant: Color(FlenxPalette.argb(FlenxPalette.border)),
          onSurface: Color(FlenxPalette.argb(FlenxPalette.ink)),
        ),
        scaffold: const Color(0xFFF6F8FB),
      );

  static ThemeData dark({Color? seed}) => _build(
        scheme: ColorScheme.fromSeed(
          seedColor: seed ?? brand,
          brightness: Brightness.dark,
        ).copyWith(
          surface: Color(FlenxPalette.argb(FlenxPalette.darkSurface)),
          outlineVariant: Color(FlenxPalette.argb(FlenxPalette.darkBorder)),
          onSurface: Color(FlenxPalette.argb(FlenxPalette.darkInk)),
        ),
        scaffold: Color(FlenxPalette.argb(FlenxPalette.darkBg)),
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
