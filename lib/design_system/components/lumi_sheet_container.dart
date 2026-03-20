import 'package:flutter/material.dart';
import 'package:lumi/design_system/primitives/lumi_surface.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';

class LumiSheetContainer extends StatelessWidget {
  const LumiSheetContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final insets = context.lumiInsets;
    final shapes = context.lumiShapes;
    final safePadding = MediaQuery.paddingOf(context);
    final bottomOffset =
        safePadding.bottom +
        insets.controlMinHeight +
        insets.barVertical +
        (insets.clusterGap * 4);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        insets.screenHorizontal,
        insets.sectionGap,
        insets.screenHorizontal,
        bottomOffset,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: shapes.bar,
              boxShadow: [
                BoxShadow(
                  color: colors.contentPrimary.withValues(alpha: 0.08),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
                BoxShadow(
                  color: colors.borderPrimary.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: LumiSurface(
              tone: LumiSurfaceTone.secondary,
              shape: LumiSurfaceShape.bar,
              border: true,
              padding: insets.cardPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: insets.controlMinHeight,
                    height: insets.clusterGap / 2,
                    margin: EdgeInsets.only(bottom: insets.itemGap),
                    decoration: BoxDecoration(
                      color: colors.borderSecondary,
                      borderRadius: shapes.pill,
                    ),
                  ),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
