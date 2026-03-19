import 'package:flutter/material.dart';

@immutable
class LumiColorTokenScale {
  const LumiColorTokenScale({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.inverse,
    required this.ghost,
    required this.info,
    required this.danger,
    required this.success,
    required this.warning,
    required this.disabled,
  });

  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color inverse;
  final Color ghost;
  final Color info;
  final Color danger;
  final Color success;
  final Color warning;
  final Color disabled;
}

@immutable
class LumiColorTokens {
  const LumiColorTokens({
    required this.background,
    required this.text,
    required this.border,
  });

  final LumiColorTokenScale background;
  final LumiColorTokenScale text;
  final LumiColorTokenScale border;

  static const light = LumiColorTokens(
    background: LumiColorTokenScale(
      primary: Color(0xFFFCFCFC),
      secondary: Color(0xFFF0F0F0),
      tertiary: Color(0xFFF5F5F5),
      inverse: Color(0xFF141413),
      ghost: Color(0x00FFFFFF),
      info: Color(0xFFD6E4F6),
      danger: Color(0xFFB53333),
      success: Color(0xFFE9F1DC),
      warning: Color(0xFFF6EEDF),
      disabled: Color(0x80FFFFFF),
    ),
    text: LumiColorTokenScale(
      primary: Color(0xFF141413),
      secondary: Color(0xFF3D3D3A),
      tertiary: Color(0xB36B6A86),
      inverse: Color(0xFFFFFFFF),
      ghost: Color(0x8073726C),
      info: Color(0xFF3266AD),
      danger: Color(0xFF7F2C28),
      success: Color(0xFF265B19),
      warning: Color(0xFF5A4815),
      disabled: Color(0x80141413),
    ),
    border: LumiColorTokenScale(
      primary: Color(0x661F1E1D),
      secondary: Color(0x4D1F1E1D),
      tertiary: Color(0x261F1E1D),
      inverse: Color(0x4DFFFFFF),
      ghost: Color(0x0D1F1E1D),
      info: Color(0xFF4682D5),
      danger: Color(0xFFA73D39),
      success: Color(0xFF437426),
      warning: Color(0xFF805C1F),
      disabled: Color(0x1A1F1E1D),
    ),
  );

  static const dark = LumiColorTokens(
    background: LumiColorTokenScale(
      primary: Color(0xFF30302E),
      secondary: Color(0xFF262624),
      tertiary: Color(0xFF141413),
      inverse: Color(0xFFFAF9F5),
      ghost: Color(0x0030302E),
      info: Color(0xFF253E5F),
      danger: Color(0xFFDD5353),
      success: Color(0xFF1B4614),
      warning: Color(0xFF483A0F),
      disabled: Color(0x8030302E),
    ),
    text: LumiColorTokenScale(
      primary: Color(0xFFFAF9F5),
      secondary: Color(0xFFC2C0B6),
      tertiary: Color(0xFF9C9A92),
      inverse: Color(0xFF141413),
      ghost: Color(0x809C9A92),
      info: Color(0xFF80AADD),
      danger: Color(0xFFEE8884),
      success: Color(0xFF7AB948),
      warning: Color(0xFFD1A041),
      disabled: Color(0x80FAF9F5),
    ),
    border: LumiColorTokenScale(
      primary: Color(0x66DEDCD1),
      secondary: Color(0x4DDEDCD1),
      tertiary: Color(0x26DEDCD1),
      inverse: Color(0x26141413),
      ghost: Color(0x1ADEDCD1),
      info: Color(0xFF4682D5),
      danger: Color(0xFFCD5C58),
      success: Color(0xFF599130),
      warning: Color(0xFFA87829),
      disabled: Color(0x1ADEDCD1),
    ),
  );
}
