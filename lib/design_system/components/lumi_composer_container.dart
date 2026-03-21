import 'package:flutter/material.dart';
import 'package:lumi/design_system/motion/lumi_motion.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';
import 'package:lumi/design_system/tokens/lumi_spacing_tokens.dart';

class LumiComposerContainer extends StatelessWidget {
  const LumiComposerContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final insets = context.lumiInsets;
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final safePadding = MediaQuery.paddingOf(context);
    final footerClearance =
        safePadding.bottom +
        insets.controlMinHeight +
        insets.barVertical +
        (insets.clusterGap * 4);
    final bottomInset = viewInsets.bottom > 0
        ? viewInsets.bottom
        : footerClearance;

    return AnimatedPadding(
      duration: LumiMotion.composer.duration,
      curve: LumiMotion.composer.curve,
      padding: EdgeInsets.fromLTRB(
        safePadding.left,
        0,
        safePadding.right,
        bottomInset,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            insets.screenHorizontal,
            insets.cardPaddingValue,
            insets.screenHorizontal,
            LumiSpacingTokens.space7,
          ),
          decoration: BoxDecoration(
            color: colors.surfacePrimary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(insets.cardPaddingValue),
              topRight: Radius.circular(insets.cardPaddingValue),
            ),
            border: Border(top: BorderSide(color: colors.scrim)),
          ),
          child: child,
        ),
      ),
    );
  }
}
