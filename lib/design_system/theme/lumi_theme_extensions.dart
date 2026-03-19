import 'package:flutter/material.dart';
import 'package:lumi/design_system/theme/lumi_semantic_theme.dart';

extension LumiThemeContextX on BuildContext {
  ThemeData get lumiTheme => Theme.of(this);

  TextTheme get lumiTextTheme => lumiTheme.textTheme;

  LumiColors get lumiColors =>
      lumiTheme.extension<LumiColors>() ??
      (throw StateError('LumiColors theme extension is not registered.'));

  LumiInsets get lumiInsets =>
      lumiTheme.extension<LumiInsets>() ??
      (throw StateError('LumiInsets theme extension is not registered.'));

  LumiShapes get lumiShapes =>
      lumiTheme.extension<LumiShapes>() ??
      (throw StateError('LumiShapes theme extension is not registered.'));
}
