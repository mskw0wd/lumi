import 'package:flutter/material.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';
import 'package:lumi/design_system/tokens/lumi_typography_tokens.dart';

const _kComposerPlaceholderColor = Color(0xFF9E9E9E);

enum LumiTextFieldVariant { standard, composer }

class LumiTextField extends StatelessWidget {
  const LumiTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction,
    this.onSubmitted,
    this.enabled = true,
    this.variant = LumiTextFieldVariant.standard,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final bool autofocus;
  final int maxLines;
  final int? minLines;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final LumiTextFieldVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final insets = context.lumiInsets;
    final shapes = context.lumiShapes;
    final textTheme = context.lumiTextTheme;
    final isComposer = variant == LumiTextFieldVariant.composer;
    final fillColor = isComposer
        ? colors.surfaceGhost
        : colors.surfaceSecondary;
    final enabledBorderColor = colors.borderTertiary;
    final focusedBorderColor = isComposer
        ? colors.borderTertiary
        : colors.borderPrimary;
    final verticalPadding = isComposer ? 0.0 : insets.pillVertical;
    final horizontalPadding = isComposer ? 0.0 : insets.cardPaddingValue;
    final composerBorder = InputBorder.none;
    final outlinedBorder = OutlineInputBorder(
      borderRadius: shapes.panel,
      borderSide: BorderSide(color: enabledBorderColor),
    );
    final focusedOutlinedBorder = OutlineInputBorder(
      borderRadius: shapes.panel,
      borderSide: BorderSide(color: focusedBorderColor),
    );

    return TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      maxLines: maxLines,
      minLines: minLines,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      enabled: enabled,
      style: isComposer
          ? textTheme.bodyMedium?.copyWith(
              color: colors.contentPrimary,
              fontWeight: LumiTypographyTokens.medium,
            )
          : textTheme.bodyLarge?.copyWith(color: colors.contentPrimary),
      cursorColor: colors.contentPrimary,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: (isComposer ? textTheme.bodyMedium : textTheme.bodyLarge)
            ?.copyWith(
              color: isComposer
                  ? _kComposerPlaceholderColor
                  : colors.contentSecondary,
              fontWeight: isComposer
                  ? LumiTypographyTokens.medium
                  : LumiTypographyTokens.regular,
            ),
        filled: !isComposer,
        fillColor: fillColor,
        contentPadding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        border: isComposer ? composerBorder : outlinedBorder,
        enabledBorder: isComposer ? composerBorder : outlinedBorder,
        focusedBorder: isComposer ? composerBorder : focusedOutlinedBorder,
        disabledBorder: isComposer ? composerBorder : outlinedBorder,
      ),
    );
  }
}
