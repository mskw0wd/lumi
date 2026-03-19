import 'package:flutter/material.dart';
import 'package:lumi/app/shell/lumi_bottom_bar.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';

class LumiAppShell extends StatelessWidget {
  const LumiAppShell({
    super.key,
    required this.currentLocation,
    required this.child,
  });

  final String currentLocation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;

    return Scaffold(
      body: ColoredBox(color: colors.appBackground, child: child),
      bottomNavigationBar: LumiBottomBar(currentLocation: currentLocation),
    );
  }
}
