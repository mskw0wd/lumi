import 'package:flutter/material.dart';
import 'package:lumi/design_system/theme/lumi_semantic_theme.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';

enum LumiSurfaceTone { primary, secondary, tertiary, inverse, ghost }

enum LumiSurfaceShape { panel, pill, bar }

class LumiSurface extends StatelessWidget {
  const LumiSurface({
    super.key,
    required this.child,
    this.tone = LumiSurfaceTone.primary,
    this.shape = LumiSurfaceShape.panel,
    this.padding,
    this.margin,
    this.alignment,
    this.border = false,
    this.borderColor,
    this.constraints,
  });

  final Widget child;
  final LumiSurfaceTone tone;
  final LumiSurfaceShape shape;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;
  final bool border;
  final Color? borderColor;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final shapes = context.lumiShapes;

    return Container(
      margin: margin,
      padding: padding,
      alignment: alignment,
      constraints: constraints,
      decoration: BoxDecoration(
        color: _resolveColor(colors),
        borderRadius: _resolveShape(shapes),
        border: border
            ? Border.all(color: borderColor ?? colors.borderTertiary)
            : null,
      ),
      child: child,
    );
  }

  Color _resolveColor(LumiColors colors) {
    return switch (tone) {
      LumiSurfaceTone.primary => colors.surfacePrimary,
      LumiSurfaceTone.secondary => colors.surfaceSecondary,
      LumiSurfaceTone.tertiary => colors.surfaceTertiary,
      LumiSurfaceTone.inverse => colors.surfaceInverse,
      LumiSurfaceTone.ghost => colors.surfaceGhost,
    };
  }

  BorderRadius _resolveShape(LumiShapes shapes) {
    return switch (shape) {
      LumiSurfaceShape.panel => shapes.panel,
      LumiSurfaceShape.pill => shapes.pill,
      LumiSurfaceShape.bar => shapes.bar,
    };
  }
}
