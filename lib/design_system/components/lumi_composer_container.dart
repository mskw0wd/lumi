import 'package:flutter/material.dart';
import 'package:lumi/design_system/motion/lumi_motion.dart';
import 'package:lumi/design_system/primitives/lumi_surface.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';

class LumiComposerContainer extends StatelessWidget {
  const LumiComposerContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final insets = context.lumiInsets;
    final shapes = context.lumiShapes;
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final safePadding = MediaQuery.paddingOf(context);
    final footerClearance =
        safePadding.bottom +
        insets.controlMinHeight +
        insets.barVertical +
        (insets.clusterGap * 4);
    final bottomInset = viewInsets.bottom > 0
        ? viewInsets.bottom + insets.clusterGap
        : footerClearance;

    return AnimatedPadding(
      duration: LumiMotion.composer.duration,
      curve: LumiMotion.composer.curve,
      padding: EdgeInsets.fromLTRB(
        insets.screenHorizontal,
        insets.sectionGap,
        insets.screenHorizontal,
        bottomInset,
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
              tone: LumiSurfaceTone.primary,
              shape: LumiSurfaceShape.bar,
              border: true,
              padding: insets.cardPadding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
