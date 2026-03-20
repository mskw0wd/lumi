import 'package:flutter/material.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';

class LumiAppScaffold extends StatelessWidget {
  const LumiAppScaffold({
    super.key,
    required this.body,
    this.bottomBar,
    this.overlay,
  });

  final Widget body;
  final Widget? bottomBar;
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ColoredBox(
        color: colors.appBackground,
        child: Stack(
          fit: StackFit.expand,
          children: [
            body,
            if (bottomBar != null)
              Align(alignment: Alignment.bottomCenter, child: bottomBar!),
            if (overlay != null) Positioned.fill(child: overlay!),
          ],
        ),
      ),
    );
  }
}
