import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lumi/app/overlays/app_overlay_controller.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';
import 'package:lumi/design_system/tokens/lumi_spacing_tokens.dart';
import 'package:lumi/design_system/tokens/lumi_typography_tokens.dart';

class InboxPage extends ConsumerWidget {
  const InboxPage({super.key});

  static const routeName = 'inbox';
  static const routePath = '/inbox';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _InboxPageBody();
  }
}

class _InboxPageBody extends ConsumerStatefulWidget {
  const _InboxPageBody();

  @override
  ConsumerState<_InboxPageBody> createState() => _InboxPageState();
}

class _InboxPageState extends ConsumerState<_InboxPageBody> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final insets = context.lumiInsets;
    final textTheme = context.lumiTextTheme;
    final overlayController = ref.read(appOverlayControllerProvider.notifier);
    const relativeDateLabel = 'Today';
    const absoluteDateLabel = 'Tue, March 16';
    final largeDateStyle = textTheme.displayLarge?.copyWith(
      color: colors.contentPrimary,
    );
    final compactDateStyle = textTheme.titleMedium?.copyWith(
      color: colors.contentPrimary,
      fontSize: 20,
      height: LumiTypographyTokens.h5.height,
      letterSpacing: LumiTypographyTokens.h5.letterSpacing,
      fontWeight: LumiTypographyTokens.medium,
    );

    return SafeArea(
      bottom: false,
      child: AnimatedBuilder(
        animation: _scrollController,
        child: _TaskPreviewList(controller: _scrollController),
        builder: (context, child) {
          final offset = _scrollController.hasClients
              ? _scrollController.offset
              : 0.0;
          final collapseProgress = Curves.easeOutCubic.transform(
            _normalizedProgress(offset, 0, 72),
          );
          final stickyHeaderProgress = Curves.easeInOut.transform(
            _normalizedProgress(offset, 24, 76),
          );
          const topSpacing = LumiSpacingTokens.space12;
          final listSpacing = lerpDouble(
            LumiSpacingTokens.space12,
            LumiSpacingTokens.space9,
            collapseProgress,
          )!;
          final dateStyle = TextStyle.lerp(
            largeDateStyle,
            compactDateStyle,
            stickyHeaderProgress,
          );

          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      insets.screenHorizontal,
                      insets.itemGap,
                      insets.screenHorizontal,
                      0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hey, Max',
                                style: textTheme.titleLarge?.copyWith(
                                  color: colors.contentPrimary,
                                  fontWeight: LumiTypographyTokens.bold,
                                ),
                              ),
                              const SizedBox(height: LumiSpacingTokens.space1),
                              Text(
                                'Ready to start the day?',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colors.contentSecondary,
                                  fontWeight: LumiTypographyTokens.medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const _HeaderAction(
                              assetPath: 'assets/icons/overdue_default.svg',
                              iconSize: 24,
                            ),
                            const SizedBox(width: LumiSpacingTokens.space7),
                            const _HeaderAction(
                              assetPath: 'assets/icons/notification_new.svg',
                              iconSize: 24,
                            ),
                            const SizedBox(width: LumiSpacingTokens.space7),
                            const _AvatarPlaceholder(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        insets.screenHorizontal,
                        topSpacing,
                        insets.screenHorizontal,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _DateSummaryBlock(
                            relativeDateLabel: relativeDateLabel,
                            absoluteDateLabel: absoluteDateLabel,
                            dateStyle: dateStyle,
                            onTap: overlayController.showCalendar,
                            collapseProgress: collapseProgress,
                          ),
                          SizedBox(height: listSpacing),
                          Expanded(child: child!),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InboxPlaceholderRow extends StatelessWidget {
  const _InboxPlaceholderRow({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final textTheme = context.lumiTextTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: LumiSpacingTokens.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: colors.borderTertiary, width: 1.25),
            ),
          ),
          const SizedBox(width: LumiSpacingTokens.space7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.contentPrimary,
                    fontWeight: LumiTypographyTokens.medium,
                  ),
                ),
                const SizedBox(height: LumiSpacingTokens.space2),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.contentSecondary,
                    fontWeight: LumiTypographyTokens.medium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({required this.assetPath, this.iconSize = 20});

  final String assetPath;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Center(
        child: SvgPicture.asset(assetPath, width: iconSize, height: iconSize),
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;

    return Container(
      width: 44,
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colors.borderTertiary),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.surfacePrimary,
        ),
      ),
    );
  }
}

class _DateSummaryBlock extends StatelessWidget {
  const _DateSummaryBlock({
    required this.relativeDateLabel,
    required this.absoluteDateLabel,
    required this.dateStyle,
    required this.onTap,
    required this.collapseProgress,
  });

  final String relativeDateLabel;
  final String absoluteDateLabel;
  final TextStyle? dateStyle;
  final VoidCallback onTap;
  final double collapseProgress;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final textTheme = context.lumiTextTheme;
    final todayProgress = (collapseProgress / 0.65).clamp(0.0, 1.0);
    final summaryProgress = (collapseProgress / 0.85).clamp(0.0, 1.0);
    final summaryShift = lerpDouble(0, -2, summaryProgress)!;
    final summaryOpacity = lerpDouble(1, 0.74, summaryProgress)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRect(
          child: Align(
            alignment: Alignment.topLeft,
            heightFactor: lerpDouble(1, 0, todayProgress)!,
            child: Opacity(
              opacity: lerpDouble(1, 0, todayProgress)!,
              child: Transform.translate(
                offset: Offset(0, lerpDouble(0, -6, todayProgress)!),
                child: _DateTriggerLabel(
                  key: const Key('inbox-page-title'),
                  label: relativeDateLabel,
                  style: textTheme.displayLarge?.copyWith(
                    color: colors.contentSecondary,
                  ),
                  onTap: onTap,
                ),
              ),
            ),
          ),
        ),
        _DateTriggerLabel(
          label: absoluteDateLabel,
          style: dateStyle,
          onTap: onTap,
        ),
        const SizedBox(height: LumiSpacingTokens.space1),
        ClipRect(
          child: Opacity(
            opacity: summaryOpacity,
            child: Transform.translate(
              offset: Offset(0, summaryShift),
              child: RichText(
                text: TextSpan(
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.contentSecondary,
                    fontWeight: LumiTypographyTokens.medium,
                  ),
                  children: [
                    TextSpan(
                      text: '7 tasks',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.contentPrimary,
                        fontWeight: LumiTypographyTokens.medium,
                      ),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: 'to focus on',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.contentSecondary,
                        fontWeight: LumiTypographyTokens.medium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TaskPreviewList extends StatelessWidget {
  const _TaskPreviewList({required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final shapes = context.lumiShapes;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: LumiSpacingTokens.space7,
        vertical: LumiSpacingTokens.space3,
      ),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: shapes.panel.copyWith(
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero,
        ),
      ),
      child: ListView(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: const [
          _InboxPlaceholderRow(
            title: 'Refine onboarding flow',
            subtitle: 'ICVR',
          ),
          _InboxPlaceholderRow(
            title: 'Sync with design on empty states',
            subtitle: 'Coinask',
          ),
          _InboxPlaceholderRow(
            title: 'Review API pagination edge cases',
            subtitle: 'LevelLegends',
          ),
          _InboxPlaceholderRow(
            title: 'Prepare sprint demo notes',
            subtitle: 'ICVR',
          ),
          _InboxPlaceholderRow(
            title: 'Update QA checklist for release',
            subtitle: 'Lumi',
          ),
          _InboxPlaceholderRow(
            title: 'Fix calendar timezone mismatch',
            subtitle: 'Coinask',
          ),
          _InboxPlaceholderRow(
            title: 'Plan priorities for tomorrow',
            subtitle: 'Fixes',
          ),
          _InboxPlaceholderRow(
            title: 'Prepare sprint demo notes',
            subtitle: 'ICVR',
          ),
          _InboxPlaceholderRow(
            title: 'Update QA checklist for release',
            subtitle: 'Lumi',
          ),
          _InboxPlaceholderRow(
            title: 'Review notification permission UX',
            subtitle: 'Lumi',
          ),
          _InboxPlaceholderRow(
            title: 'Refine compact header transition',
            subtitle: 'Inbox',
          ),
          _InboxPlaceholderRow(
            title: 'Polish calendar bottom sheet spacing',
            subtitle: 'Fixes',
          ),
          _InboxPlaceholderRow(
            title: 'Audit icon asset states',
            subtitle: 'Design',
          ),
          _InboxPlaceholderRow(
            title: 'Prepare voice entry edge cases',
            subtitle: 'Voice',
          ),
          _InboxPlaceholderRow(
            title: 'Clean empty-state copy variants',
            subtitle: 'Lumi',
          ),
          _InboxPlaceholderRow(
            title: 'Verify keyboard attachment motion',
            subtitle: 'Composer',
          ),
          _InboxPlaceholderRow(
            title: 'Review date label compact state',
            subtitle: 'Inbox',
          ),
          _InboxPlaceholderRow(
            title: 'Update onboarding success messaging',
            subtitle: 'ICVR',
          ),
          _InboxPlaceholderRow(
            title: 'Sync project chips with latest tokens',
            subtitle: 'Design',
          ),
          _InboxPlaceholderRow(
            title: 'Check footer safe-area behavior',
            subtitle: 'Fixes',
          ),
          _InboxPlaceholderRow(
            title: 'Review avatar placeholder balance',
            subtitle: 'Profile',
          ),
          _InboxPlaceholderRow(
            title: 'Prepare release note structure',
            subtitle: 'Ops',
          ),
          _InboxPlaceholderRow(
            title: 'Polish list row spacing in dark mode',
            subtitle: 'UI',
          ),
          _InboxPlaceholderRow(
            title: 'Validate Today header rhythm',
            subtitle: 'Inbox',
          ),
        ],
      ),
    );
  }
}

double _normalizedProgress(double offset, double start, double end) {
  if (end <= start) {
    return offset >= end ? 1.0 : 0.0;
  }

  return ((offset - start) / (end - start)).clamp(0.0, 1.0);
}

class _DateTriggerLabel extends StatelessWidget {
  const _DateTriggerLabel({
    super.key,
    required this.label,
    required this.style,
    required this.onTap,
  });

  final String label;
  final TextStyle? style;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: Text(label, style: style),
        ),
      ),
    );
  }
}
