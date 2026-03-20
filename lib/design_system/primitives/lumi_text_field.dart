import 'package:flutter/material.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';

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

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final insets = context.lumiInsets;
    final shapes = context.lumiShapes;
    final textTheme = context.lumiTextTheme;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      maxLines: maxLines,
      minLines: minLines,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      enabled: enabled,
      style: textTheme.bodyLarge?.copyWith(color: colors.contentPrimary),
      cursorColor: colors.contentPrimary,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: textTheme.bodyLarge?.copyWith(color: colors.contentTertiary),
        filled: true,
        fillColor: colors.surfaceSecondary,
        contentPadding: EdgeInsets.symmetric(
          horizontal: insets.cardPaddingValue,
          vertical: insets.pillVertical,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: shapes.panel,
          borderSide: BorderSide(color: colors.borderTertiary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: shapes.panel,
          borderSide: BorderSide(color: colors.borderPrimary),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: shapes.panel,
          borderSide: BorderSide(color: colors.borderTertiary),
        ),
      ),
    );
  }
}
