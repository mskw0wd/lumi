import 'package:flutter/material.dart';
import 'package:lumi/design_system/primitives/lumi_surface.dart';
import 'package:lumi/design_system/primitives/lumi_text.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';

enum LumiPillTone { secondary, tertiary, inverse, ghost }

class LumiPill extends StatelessWidget {
  const LumiPill({
    super.key,
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.tone = LumiPillTone.secondary,
  });

  final String label;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final LumiPillTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final insets = context.lumiInsets;

    final surfaceTone = switch (tone) {
      LumiPillTone.secondary => LumiSurfaceTone.secondary,
      LumiPillTone.tertiary => LumiSurfaceTone.tertiary,
      LumiPillTone.inverse => LumiSurfaceTone.inverse,
      LumiPillTone.ghost => LumiSurfaceTone.ghost,
    };

    final textTone = tone == LumiPillTone.inverse
        ? LumiTextTone.inverse
        : LumiTextTone.secondary;
    final iconColor = tone == LumiPillTone.inverse
        ? colors.contentInverse
        : colors.contentSecondary;

    return LumiSurface(
      tone: surfaceTone,
      shape: LumiSurfaceShape.pill,
      padding: insets.pillPadding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon case final icon) ...[
            Icon(icon, size: insets.iconSize, color: iconColor),
            SizedBox(width: insets.clusterGap),
          ],
          LumiText(label, role: LumiTextRole.labelLarge, tone: textTone),
          if (trailingIcon case final icon) ...[
            SizedBox(width: insets.clusterGap),
            Icon(icon, size: insets.iconSize, color: iconColor),
          ],
        ],
      ),
    );
  }
}
