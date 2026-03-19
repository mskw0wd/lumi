import 'package:flutter/material.dart';
import 'package:lumi/app/shell/lumi_bottom_bar.dart';

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
    return Scaffold(
      body: child,
      bottomNavigationBar: LumiBottomBar(currentLocation: currentLocation),
    );
  }
}
