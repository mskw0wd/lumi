import 'package:flutter/material.dart';
import 'package:lumi/design_system/primitives/lumi_surface.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';

enum LumiIconButtonTone { secondary, inverse, ghost }

class LumiIconButton extends StatelessWidget {
  const LumiIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.tone = LumiIconButtonTone.secondary,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final LumiIconButtonTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final insets = context.lumiInsets;
    final shapes = context.lumiShapes;

    final backgroundTone = switch (tone) {
      LumiIconButtonTone.secondary => LumiSurfaceTone.secondary,
      LumiIconButtonTone.inverse => LumiSurfaceTone.inverse,
      LumiIconButtonTone.ghost => LumiSurfaceTone.ghost,
    };

    final foregroundColor = onPressed == null
        ? colors.contentDisabled
        : switch (tone) {
            LumiIconButtonTone.secondary => colors.contentPrimary,
            LumiIconButtonTone.inverse => colors.contentInverse,
            LumiIconButtonTone.ghost => colors.contentSecondary,
          };

    Widget child = Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: shapes.pill,
        onTap: onPressed,
        child: LumiSurface(
          tone: backgroundTone,
          shape: LumiSurfaceShape.pill,
          padding: insets.pillPadding,
          child: Icon(icon, size: insets.iconSize, color: foregroundColor),
        ),
      ),
    );

    if (tooltip case final message?) {
      child = Tooltip(message: message, child: child);
    }

    return child;
  }
}
