import 'package:flutter/material.dart';
import 'package:lumi/app/overlays/app_overlay_host.dart';
import 'package:lumi/app/shell/lumi_bottom_bar.dart';
import 'package:lumi/design_system/primitives/lumi_app_scaffold.dart';

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
    return LumiAppScaffold(
      body: child,
      bottomBar: LumiBottomBar(currentLocation: currentLocation),
      overlay: const AppOverlayHost(),
    );
  }
}
