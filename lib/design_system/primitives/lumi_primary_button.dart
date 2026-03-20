import 'package:flutter/material.dart';
import 'package:lumi/design_system/primitives/lumi_surface.dart';
import 'package:lumi/design_system/primitives/lumi_text.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';

class LumiPrimaryButton extends StatelessWidget {
  const LumiPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.leadingIcon,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final insets = context.lumiInsets;
    final shapes = context.lumiShapes;

    final backgroundTone = onPressed == null
        ? LumiSurfaceTone.tertiary
        : LumiSurfaceTone.inverse;
    final foregroundTone = onPressed == null
        ? LumiTextTone.disabled
        : LumiTextTone.inverse;

    Widget child = Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: shapes.pill,
        onTap: onPressed,
        child: LumiSurface(
          tone: backgroundTone,
          shape: LumiSurfaceShape.pill,
          padding: insets.pillPadding,
          constraints: BoxConstraints(minHeight: insets.controlMinHeight),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon case final icon) ...[
                Icon(
                  icon,
                  size: insets.iconSize,
                  color: onPressed == null
                      ? colors.contentDisabled
                      : colors.contentInverse,
                ),
                SizedBox(width: insets.itemGap),
              ],
              LumiText(
                label,
                role: LumiTextRole.labelLarge,
                tone: foregroundTone,
              ),
            ],
          ),
        ),
      ),
    );

    if (expand) {
      child = SizedBox(width: double.infinity, child: child);
    }

    return child;
  }
}
