import 'package:flutter/material.dart';
import 'package:lumi/design_system/theme/lumi_semantic_theme.dart';
import 'package:lumi/design_system/tokens/lumi_color_tokens.dart';
import 'package:lumi/design_system/tokens/lumi_typography_tokens.dart';

abstract final class LumiTheme {
  static ThemeData light() => _buildTheme(
    brightness: Brightness.light,
    colorTokens: LumiColorTokens.light,
  );

  static ThemeData dark() => _buildTheme(
    brightness: Brightness.dark,
    colorTokens: LumiColorTokens.dark,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required LumiColorTokens colorTokens,
  }) {
    final semanticTheme = LumiSemanticTheme.fromTokens(colorTokens);
    final colors = semanticTheme.colors;

    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: colors.statusInfo,
          brightness: brightness,
        ).copyWith(
          surface: colors.surfacePrimary,
          onSurface: colors.contentPrimary,
          primary: colors.statusInfo,
          onPrimary: colors.contentInverse,
          secondary: colors.surfaceSecondary,
          onSecondary: colors.contentPrimary,
          error: colors.statusDanger,
          onError: colors.contentInverse,
          outline: colors.borderPrimary,
          outlineVariant: colors.borderTertiary,
          inverseSurface: colors.surfaceInverse,
          onInverseSurface: colors.contentInverse,
          shadow: colors.surfaceGhost,
          scrim: colors.surfaceGhost,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.appBackground,
      fontFamily: LumiTypographyTokens.bodyFamily,
      textTheme: _buildTextTheme(colors),
      dividerColor: colors.borderTertiary,
      extensions: [
        semanticTheme.colors,
        semanticTheme.insets,
        semanticTheme.shapes,
      ],
    );
  }

  static TextTheme _buildTextTheme(LumiColors colors) {
    return TextTheme(
      displayLarge: _style(
        LumiTypographyTokens.h1,
        fontWeight: LumiTypographyTokens.bold,
        color: colors.contentPrimary,
      ),
      displayMedium: _style(
        LumiTypographyTokens.h2,
        fontWeight: LumiTypographyTokens.bold,
        color: colors.contentPrimary,
      ),
      displaySmall: _style(
        LumiTypographyTokens.h3,
        fontWeight: LumiTypographyTokens.medium,
        color: colors.contentPrimary,
      ),
      headlineLarge: _style(
        LumiTypographyTokens.h4,
        fontWeight: LumiTypographyTokens.medium,
        color: colors.contentPrimary,
      ),
      headlineMedium: _style(
        LumiTypographyTokens.h5,
        fontWeight: LumiTypographyTokens.medium,
        color: colors.contentPrimary,
      ),
      headlineSmall: _style(
        LumiTypographyTokens.h6,
        fontWeight: LumiTypographyTokens.medium,
        color: colors.contentPrimary,
      ),
      titleLarge: _style(
        LumiTypographyTokens.h5,
        fontWeight: LumiTypographyTokens.medium,
        color: colors.contentPrimary,
      ),
      titleMedium: _style(
        LumiTypographyTokens.h6,
        fontWeight: LumiTypographyTokens.medium,
        color: colors.contentPrimary,
      ),
      bodyLarge: _style(
        LumiTypographyTokens.large,
        fontWeight: LumiTypographyTokens.regular,
        color: colors.contentPrimary,
      ),
      bodyMedium: _style(
        LumiTypographyTokens.mediumBody,
        fontWeight: LumiTypographyTokens.regular,
        color: colors.contentPrimary,
      ),
      bodySmall: _style(
        LumiTypographyTokens.small,
        fontWeight: LumiTypographyTokens.regular,
        color: colors.contentSecondary,
      ),
      labelLarge: _style(
        LumiTypographyTokens.small,
        fontWeight: LumiTypographyTokens.medium,
        color: colors.contentPrimary,
      ),
      labelMedium: _style(
        LumiTypographyTokens.xSmall,
        fontWeight: LumiTypographyTokens.medium,
        color: colors.contentSecondary,
      ),
      labelSmall: _style(
        LumiTypographyTokens.micro,
        fontWeight: LumiTypographyTokens.medium,
        color: colors.contentSecondary,
      ),
    );
  }

  static TextStyle _style(
    LumiTextToken token, {
    required FontWeight fontWeight,
    required Color color,
  }) {
    return TextStyle(
      fontFamily: LumiTypographyTokens.bodyFamily,
      fontSize: token.fontSize,
      height: token.height,
      letterSpacing: token.letterSpacing,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
