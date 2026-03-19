import 'package:flutter/material.dart';

@immutable
class LumiTextToken {
  const LumiTextToken({
    required this.fontSize,
    required this.lineHeight,
    required this.letterSpacing,
  });

  final double fontSize;
  final double lineHeight;
  final double letterSpacing;

  double get height => lineHeight / fontSize;
}

abstract final class LumiTypographyTokens {
  static const String titleFamily = 'PT Root UI';
  static const String bodyFamily = 'PT Root UI';

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight bold = FontWeight.w700;

  static const LumiTextToken h1 = LumiTextToken(
    fontSize: 40,
    lineHeight: 48,
    letterSpacing: -1.5,
  );
  static const LumiTextToken h2 = LumiTextToken(
    fontSize: 34,
    lineHeight: 40,
    letterSpacing: -0.7,
  );
  static const LumiTextToken h3 = LumiTextToken(
    fontSize: 28,
    lineHeight: 34,
    letterSpacing: -0.4,
  );
  static const LumiTextToken h4 = LumiTextToken(
    fontSize: 24,
    lineHeight: 30,
    letterSpacing: -0.3,
  );
  static const LumiTextToken h5 = LumiTextToken(
    fontSize: 20,
    lineHeight: 26,
    letterSpacing: -0.2,
  );
  static const LumiTextToken h6 = LumiTextToken(
    fontSize: 18,
    lineHeight: 24,
    letterSpacing: -0.1,
  );
  static const LumiTextToken xSmall = LumiTextToken(
    fontSize: 12,
    lineHeight: 18,
    letterSpacing: -0.3,
  );
  static const LumiTextToken micro = LumiTextToken(
    fontSize: 13,
    lineHeight: 14,
    letterSpacing: -0.2,
  );
  static const LumiTextToken small = LumiTextToken(
    fontSize: 14,
    lineHeight: 20,
    letterSpacing: -0.5,
  );
  static const LumiTextToken mediumBody = LumiTextToken(
    fontSize: 16,
    lineHeight: 24,
    letterSpacing: -0.6,
  );
  static const LumiTextToken large = LumiTextToken(
    fontSize: 18,
    lineHeight: 26,
    letterSpacing: -0.8,
  );
  static const LumiTextToken xLarge = LumiTextToken(
    fontSize: 20,
    lineHeight: 30,
    letterSpacing: -0.9,
  );
}
