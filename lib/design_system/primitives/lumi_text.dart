import 'package:flutter/material.dart';
import 'package:lumi/design_system/theme/lumi_semantic_theme.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';

enum LumiTextRole {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
}

enum LumiTextTone {
  primary,
  secondary,
  tertiary,
  inverse,
  disabled,
  info,
  danger,
  success,
  warning,
}

class LumiText extends StatelessWidget {
  const LumiText(
    this.data, {
    super.key,
    this.role = LumiTextRole.bodyMedium,
    this.tone = LumiTextTone.primary,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.fontWeight,
  });

  final String data;
  final LumiTextRole role;
  final LumiTextTone tone;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.lumiTextTheme;

    return Text(
      data,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: _resolveStyle(textTheme)?.copyWith(
        color: _resolveColor(context.lumiColors),
        fontWeight: fontWeight,
      ),
    );
  }

  TextStyle? _resolveStyle(TextTheme textTheme) {
    return switch (role) {
      LumiTextRole.displayLarge => textTheme.displayLarge,
      LumiTextRole.displayMedium => textTheme.displayMedium,
      LumiTextRole.displaySmall => textTheme.displaySmall,
      LumiTextRole.headlineLarge => textTheme.headlineLarge,
      LumiTextRole.headlineMedium => textTheme.headlineMedium,
      LumiTextRole.headlineSmall => textTheme.headlineSmall,
      LumiTextRole.titleLarge => textTheme.titleLarge,
      LumiTextRole.titleMedium => textTheme.titleMedium,
      LumiTextRole.bodyLarge => textTheme.bodyLarge,
      LumiTextRole.bodyMedium => textTheme.bodyMedium,
      LumiTextRole.bodySmall => textTheme.bodySmall,
      LumiTextRole.labelLarge => textTheme.labelLarge,
      LumiTextRole.labelMedium => textTheme.labelMedium,
      LumiTextRole.labelSmall => textTheme.labelSmall,
    };
  }

  Color _resolveColor(LumiColors colors) {
    return switch (tone) {
      LumiTextTone.primary => colors.contentPrimary,
      LumiTextTone.secondary => colors.contentSecondary,
      LumiTextTone.tertiary => colors.contentTertiary,
      LumiTextTone.inverse => colors.contentInverse,
      LumiTextTone.disabled => colors.contentDisabled,
      LumiTextTone.info => colors.statusInfo,
      LumiTextTone.danger => colors.statusDanger,
      LumiTextTone.success => colors.statusSuccess,
      LumiTextTone.warning => colors.statusWarning,
    };
  }
}
