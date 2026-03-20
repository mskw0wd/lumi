import 'package:flutter/material.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';

enum LumiDividerTone { primary, secondary, tertiary, inverse }

class LumiDivider extends StatelessWidget {
  const LumiDivider({
    super.key,
    this.axis = Axis.horizontal,
    this.tone = LumiDividerTone.tertiary,
    this.thickness = 1,
  });

  final Axis axis;
  final LumiDividerTone tone;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final color = switch (tone) {
      LumiDividerTone.primary => colors.borderPrimary,
      LumiDividerTone.secondary => colors.borderSecondary,
      LumiDividerTone.tertiary => colors.borderTertiary,
      LumiDividerTone.inverse => colors.borderInverse,
    };

    return SizedBox(
      height: axis == Axis.horizontal ? thickness : null,
      width: axis == Axis.vertical ? thickness : null,
      child: DecoratedBox(decoration: BoxDecoration(color: color)),
    );
  }
}
