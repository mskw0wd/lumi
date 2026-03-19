import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:lumi/design_system/tokens/lumi_color_tokens.dart';
import 'package:lumi/design_system/tokens/lumi_radius_tokens.dart';
import 'package:lumi/design_system/tokens/lumi_spacing_tokens.dart';

@immutable
class LumiSemanticTheme {
  const LumiSemanticTheme({
    required this.colors,
    required this.insets,
    required this.shapes,
  });

  factory LumiSemanticTheme.fromTokens(LumiColorTokens tokens) {
    return LumiSemanticTheme(
      colors: LumiColors(
        appBackground: tokens.background.primary,
        surfacePrimary: tokens.background.primary,
        surfaceSecondary: tokens.background.secondary,
        surfaceTertiary: tokens.background.tertiary,
        surfaceInverse: tokens.background.inverse,
        surfaceGhost: tokens.background.ghost,
        contentPrimary: tokens.text.primary,
        contentSecondary: tokens.text.secondary,
        contentTertiary: tokens.text.tertiary,
        contentInverse: tokens.text.inverse,
        contentDisabled: tokens.text.disabled,
        borderPrimary: tokens.border.primary,
        borderSecondary: tokens.border.secondary,
        borderTertiary: tokens.border.tertiary,
        borderInverse: tokens.border.inverse,
        statusInfo: tokens.text.info,
        statusDanger: tokens.text.danger,
        statusSuccess: tokens.text.success,
        statusWarning: tokens.text.warning,
      ),
      insets: const LumiInsets(
        screenHorizontal: LumiSpacingTokens.space10,
        screenTop: LumiSpacingTokens.space10,
        screenBottom: LumiSpacingTokens.space10,
        sectionGap: LumiSpacingTokens.space10,
        itemGap: LumiSpacingTokens.space5,
        clusterGap: LumiSpacingTokens.space4,
        cardPaddingValue: LumiSpacingTokens.space7,
        pillHorizontal: LumiSpacingTokens.space5,
        pillVertical: LumiSpacingTokens.space4,
        barVertical: LumiSpacingTokens.space6,
      ),
      shapes: const LumiShapes(
        panel: BorderRadius.all(Radius.circular(LumiRadiusTokens.mobileL)),
        pill: BorderRadius.all(Radius.circular(LumiRadiusTokens.mobileFull)),
        bar: BorderRadius.all(Radius.circular(LumiRadiusTokens.mobileXL)),
      ),
    );
  }

  final LumiColors colors;
  final LumiInsets insets;
  final LumiShapes shapes;
}

@immutable
class LumiColors extends ThemeExtension<LumiColors> {
  const LumiColors({
    required this.appBackground,
    required this.surfacePrimary,
    required this.surfaceSecondary,
    required this.surfaceTertiary,
    required this.surfaceInverse,
    required this.surfaceGhost,
    required this.contentPrimary,
    required this.contentSecondary,
    required this.contentTertiary,
    required this.contentInverse,
    required this.contentDisabled,
    required this.borderPrimary,
    required this.borderSecondary,
    required this.borderTertiary,
    required this.borderInverse,
    required this.statusInfo,
    required this.statusDanger,
    required this.statusSuccess,
    required this.statusWarning,
  });

  final Color appBackground;
  final Color surfacePrimary;
  final Color surfaceSecondary;
  final Color surfaceTertiary;
  final Color surfaceInverse;
  final Color surfaceGhost;
  final Color contentPrimary;
  final Color contentSecondary;
  final Color contentTertiary;
  final Color contentInverse;
  final Color contentDisabled;
  final Color borderPrimary;
  final Color borderSecondary;
  final Color borderTertiary;
  final Color borderInverse;
  final Color statusInfo;
  final Color statusDanger;
  final Color statusSuccess;
  final Color statusWarning;

  @override
  LumiColors copyWith({
    Color? appBackground,
    Color? surfacePrimary,
    Color? surfaceSecondary,
    Color? surfaceTertiary,
    Color? surfaceInverse,
    Color? surfaceGhost,
    Color? contentPrimary,
    Color? contentSecondary,
    Color? contentTertiary,
    Color? contentInverse,
    Color? contentDisabled,
    Color? borderPrimary,
    Color? borderSecondary,
    Color? borderTertiary,
    Color? borderInverse,
    Color? statusInfo,
    Color? statusDanger,
    Color? statusSuccess,
    Color? statusWarning,
  }) {
    return LumiColors(
      appBackground: appBackground ?? this.appBackground,
      surfacePrimary: surfacePrimary ?? this.surfacePrimary,
      surfaceSecondary: surfaceSecondary ?? this.surfaceSecondary,
      surfaceTertiary: surfaceTertiary ?? this.surfaceTertiary,
      surfaceInverse: surfaceInverse ?? this.surfaceInverse,
      surfaceGhost: surfaceGhost ?? this.surfaceGhost,
      contentPrimary: contentPrimary ?? this.contentPrimary,
      contentSecondary: contentSecondary ?? this.contentSecondary,
      contentTertiary: contentTertiary ?? this.contentTertiary,
      contentInverse: contentInverse ?? this.contentInverse,
      contentDisabled: contentDisabled ?? this.contentDisabled,
      borderPrimary: borderPrimary ?? this.borderPrimary,
      borderSecondary: borderSecondary ?? this.borderSecondary,
      borderTertiary: borderTertiary ?? this.borderTertiary,
      borderInverse: borderInverse ?? this.borderInverse,
      statusInfo: statusInfo ?? this.statusInfo,
      statusDanger: statusDanger ?? this.statusDanger,
      statusSuccess: statusSuccess ?? this.statusSuccess,
      statusWarning: statusWarning ?? this.statusWarning,
    );
  }

  @override
  LumiColors lerp(ThemeExtension<LumiColors>? other, double t) {
    if (other is! LumiColors) {
      return this;
    }

    return LumiColors(
      appBackground: Color.lerp(appBackground, other.appBackground, t)!,
      surfacePrimary: Color.lerp(surfacePrimary, other.surfacePrimary, t)!,
      surfaceSecondary: Color.lerp(
        surfaceSecondary,
        other.surfaceSecondary,
        t,
      )!,
      surfaceTertiary: Color.lerp(surfaceTertiary, other.surfaceTertiary, t)!,
      surfaceInverse: Color.lerp(surfaceInverse, other.surfaceInverse, t)!,
      surfaceGhost: Color.lerp(surfaceGhost, other.surfaceGhost, t)!,
      contentPrimary: Color.lerp(contentPrimary, other.contentPrimary, t)!,
      contentSecondary: Color.lerp(
        contentSecondary,
        other.contentSecondary,
        t,
      )!,
      contentTertiary: Color.lerp(contentTertiary, other.contentTertiary, t)!,
      contentInverse: Color.lerp(contentInverse, other.contentInverse, t)!,
      contentDisabled: Color.lerp(contentDisabled, other.contentDisabled, t)!,
      borderPrimary: Color.lerp(borderPrimary, other.borderPrimary, t)!,
      borderSecondary: Color.lerp(borderSecondary, other.borderSecondary, t)!,
      borderTertiary: Color.lerp(borderTertiary, other.borderTertiary, t)!,
      borderInverse: Color.lerp(borderInverse, other.borderInverse, t)!,
      statusInfo: Color.lerp(statusInfo, other.statusInfo, t)!,
      statusDanger: Color.lerp(statusDanger, other.statusDanger, t)!,
      statusSuccess: Color.lerp(statusSuccess, other.statusSuccess, t)!,
      statusWarning: Color.lerp(statusWarning, other.statusWarning, t)!,
    );
  }
}

@immutable
class LumiInsets extends ThemeExtension<LumiInsets> {
  const LumiInsets({
    required this.screenHorizontal,
    required this.screenTop,
    required this.screenBottom,
    required this.sectionGap,
    required this.itemGap,
    required this.clusterGap,
    required this.cardPaddingValue,
    required this.pillHorizontal,
    required this.pillVertical,
    required this.barVertical,
  });

  final double screenHorizontal;
  final double screenTop;
  final double screenBottom;
  final double sectionGap;
  final double itemGap;
  final double clusterGap;
  final double cardPaddingValue;
  final double pillHorizontal;
  final double pillVertical;
  final double barVertical;

  EdgeInsets get pagePadding => EdgeInsets.fromLTRB(
    screenHorizontal,
    screenTop,
    screenHorizontal,
    screenBottom,
  );

  EdgeInsets get cardPadding => EdgeInsets.all(cardPaddingValue);

  EdgeInsets get pillPadding =>
      EdgeInsets.symmetric(horizontal: pillHorizontal, vertical: pillVertical);

  EdgeInsets get bottomBarPadding => EdgeInsets.fromLTRB(
    screenHorizontal,
    barVertical,
    screenHorizontal,
    barVertical,
  );

  @override
  LumiInsets copyWith({
    double? screenHorizontal,
    double? screenTop,
    double? screenBottom,
    double? sectionGap,
    double? itemGap,
    double? clusterGap,
    double? cardPaddingValue,
    double? pillHorizontal,
    double? pillVertical,
    double? barVertical,
  }) {
    return LumiInsets(
      screenHorizontal: screenHorizontal ?? this.screenHorizontal,
      screenTop: screenTop ?? this.screenTop,
      screenBottom: screenBottom ?? this.screenBottom,
      sectionGap: sectionGap ?? this.sectionGap,
      itemGap: itemGap ?? this.itemGap,
      clusterGap: clusterGap ?? this.clusterGap,
      cardPaddingValue: cardPaddingValue ?? this.cardPaddingValue,
      pillHorizontal: pillHorizontal ?? this.pillHorizontal,
      pillVertical: pillVertical ?? this.pillVertical,
      barVertical: barVertical ?? this.barVertical,
    );
  }

  @override
  LumiInsets lerp(ThemeExtension<LumiInsets>? other, double t) {
    if (other is! LumiInsets) {
      return this;
    }

    return LumiInsets(
      screenHorizontal: lerpDouble(
        screenHorizontal,
        other.screenHorizontal,
        t,
      )!,
      screenTop: lerpDouble(screenTop, other.screenTop, t)!,
      screenBottom: lerpDouble(screenBottom, other.screenBottom, t)!,
      sectionGap: lerpDouble(sectionGap, other.sectionGap, t)!,
      itemGap: lerpDouble(itemGap, other.itemGap, t)!,
      clusterGap: lerpDouble(clusterGap, other.clusterGap, t)!,
      cardPaddingValue: lerpDouble(
        cardPaddingValue,
        other.cardPaddingValue,
        t,
      )!,
      pillHorizontal: lerpDouble(pillHorizontal, other.pillHorizontal, t)!,
      pillVertical: lerpDouble(pillVertical, other.pillVertical, t)!,
      barVertical: lerpDouble(barVertical, other.barVertical, t)!,
    );
  }
}

@immutable
class LumiShapes extends ThemeExtension<LumiShapes> {
  const LumiShapes({
    required this.panel,
    required this.pill,
    required this.bar,
  });

  final BorderRadius panel;
  final BorderRadius pill;
  final BorderRadius bar;

  @override
  LumiShapes copyWith({
    BorderRadius? panel,
    BorderRadius? pill,
    BorderRadius? bar,
  }) {
    return LumiShapes(
      panel: panel ?? this.panel,
      pill: pill ?? this.pill,
      bar: bar ?? this.bar,
    );
  }

  @override
  LumiShapes lerp(ThemeExtension<LumiShapes>? other, double t) {
    if (other is! LumiShapes) {
      return this;
    }

    return LumiShapes(
      panel: BorderRadius.lerp(panel, other.panel, t)!,
      pill: BorderRadius.lerp(pill, other.pill, t)!,
      bar: BorderRadius.lerp(bar, other.bar, t)!,
    );
  }
}
