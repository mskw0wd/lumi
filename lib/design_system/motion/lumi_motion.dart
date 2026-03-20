import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

@immutable
class LumiMotionSpec {
  const LumiMotionSpec({
    required this.duration,
    required this.curve,
    this.reverseDuration,
    this.reverseCurve,
  });

  final Duration duration;
  final Curve curve;
  final Duration? reverseDuration;
  final Curve? reverseCurve;
}

abstract final class LumiMotion {
  static const tap = LumiMotionSpec(
    duration: Duration(milliseconds: 120),
    curve: Curves.easeOutCubic,
    reverseDuration: Duration(milliseconds: 90),
    reverseCurve: Curves.easeInCubic,
  );

  static const fadeScale = LumiMotionSpec(
    duration: Duration(milliseconds: 220),
    curve: Curves.easeOutCubic,
    reverseDuration: Duration(milliseconds: 180),
    reverseCurve: Curves.easeInCubic,
  );

  static const sheet = LumiMotionSpec(
    duration: Duration(milliseconds: 320),
    curve: Curves.easeOutCubic,
    reverseDuration: Duration(milliseconds: 220),
    reverseCurve: Curves.easeInCubic,
  );

  static const composer = LumiMotionSpec(
    duration: Duration(milliseconds: 260),
    curve: Curves.easeOutCubic,
    reverseDuration: Duration(milliseconds: 180),
    reverseCurve: Curves.easeInCubic,
  );

  static const state = LumiMotionSpec(
    duration: Duration(milliseconds: 200),
    curve: Curves.easeOutCubic,
    reverseDuration: Duration(milliseconds: 160),
    reverseCurve: Curves.easeInCubic,
  );

  static const list = LumiMotionSpec(
    duration: Duration(milliseconds: 220),
    curve: Curves.easeOutCubic,
    reverseDuration: Duration(milliseconds: 180),
    reverseCurve: Curves.easeInCubic,
  );
}
