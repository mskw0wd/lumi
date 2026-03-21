import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lumi/features/tasks/application/lumi_task_store.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';
import 'package:lumi/design_system/tokens/lumi_spacing_tokens.dart';
import 'package:lumi/design_system/tokens/lumi_typography_tokens.dart';

const _focusSpacesMetricsSecondary = Color(0xFF9E9E9E);
const _focusSpacesRingSize = 36.0;

class ProjectsPage extends ConsumerWidget {
  const ProjectsPage({super.key});

  static const routeName = 'projects';
  static const routePath = '/projects';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.lumiColors;
    final insets = context.lumiInsets;
    final textTheme = context.lumiTextTheme;
    final projects = ref
        .watch(lumiSpaceSummariesProvider)
        .map(_ProjectCardData.fromSummary)
        .toList(growable: false);
    final heroStats = ref.watch(focusSpacesHeroStatsProvider);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final footerClearance =
        44 +
        (insets.cardPaddingValue * 2) +
        bottomInset +
        LumiSpacingTokens.space5;

    return SafeArea(
      bottom: false,
      child: Column(
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
                const Row(
                  children: [
                    _HeaderAction(
                      assetPath: 'assets/icons/overdue_default.svg',
                      iconSize: 24,
                    ),
                    SizedBox(width: LumiSpacingTokens.space7),
                    _HeaderAction(
                      assetPath: 'assets/icons/notification_new.svg',
                      iconSize: 24,
                    ),
                    SizedBox(width: LumiSpacingTokens.space7),
                    _AvatarPlaceholder(),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                insets.screenHorizontal,
                LumiSpacingTokens.space12,
                insets.screenHorizontal,
                0,
              ),
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: footerClearance),
                itemCount: projects.length + 1,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: index == 0
                        ? LumiSpacingTokens.space12
                        : LumiSpacingTokens.space5,
                  );
                },
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _ProjectsHero(stats: heroStats);
                  }

                  return _ProjectCard(data: projects[index - 1]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectsHero extends StatelessWidget {
  const _ProjectsHero({required this.stats});

  final FocusSpacesHeroStats stats;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final textTheme = context.lumiTextTheme;
    final metricsStyle = textTheme.bodyMedium?.copyWith(
      fontSize: LumiTypographyTokens.mediumBody.fontSize,
      height: LumiTypographyTokens.mediumBody.height,
      letterSpacing: LumiTypographyTokens.mediumBody.letterSpacing,
      fontWeight: LumiTypographyTokens.medium,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Focus Spaces',
                key: const Key('projects-page-title'),
                style: textTheme.displayLarge?.copyWith(
                  color: colors.contentPrimary,
                  fontWeight: LumiTypographyTokens.bold,
                ),
              ),
              const SizedBox(height: LumiSpacingTokens.space3),
              RichText(
                text: TextSpan(
                  style: metricsStyle,
                  children: [
                    TextSpan(
                      text: '${stats.spacesNeedingAttention}',
                      style: metricsStyle?.copyWith(
                        color: colors.contentPrimary,
                        fontWeight: LumiTypographyTokens.medium,
                      ),
                    ),
                    TextSpan(
                      text: ' need attention',
                      style: metricsStyle?.copyWith(
                        color: _focusSpacesMetricsSecondary,
                        fontWeight: LumiTypographyTokens.medium,
                      ),
                    ),
                    TextSpan(
                      text: '  \u2014  ',
                      style: metricsStyle?.copyWith(
                        color: colors.contentTertiary,
                        fontWeight: LumiTypographyTokens.regular,
                      ),
                    ),
                    TextSpan(
                      text: '${stats.totalTasks}',
                      style: metricsStyle?.copyWith(
                        color: colors.contentPrimary,
                        fontWeight: LumiTypographyTokens.medium,
                      ),
                    ),
                    TextSpan(
                      text: ' tasks',
                      style: metricsStyle?.copyWith(
                        color: _focusSpacesMetricsSecondary,
                        fontWeight: LumiTypographyTokens.medium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: LumiSpacingTokens.space7),
        const _AddProjectButton(),
      ],
    );
  }
}

class _AddProjectButton extends StatelessWidget {
  const _AddProjectButton();

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;

    return SizedBox.square(
      dimension: LumiSpacingTokens.space13,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {},
          child: CustomPaint(
            painter: _DashedCirclePainter(color: colors.borderSecondary),
            child: Center(
              child: Icon(
                Icons.add_rounded,
                size: 24,
                color: colors.contentSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.data});

  final _ProjectCardData data;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final shapes = context.lumiShapes;
    final textTheme = context.lumiTextTheme;
    final titleStyle = textTheme.bodyMedium?.copyWith(
      fontSize: LumiTypographyTokens.mediumBody.fontSize,
      height: LumiTypographyTokens.mediumBody.height,
      letterSpacing: 0,
      color: colors.contentPrimary,
      fontWeight: LumiTypographyTokens.medium,
    );

    return Container(
      key: Key('space-card-${data.id}'),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: shapes.panel,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: shapes.panel,
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(LumiSpacingTokens.space8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(data.title, style: titleStyle),
                              ),
                              if (data.pinned) ...[
                                const SizedBox(width: LumiSpacingTokens.space2),
                                Opacity(
                                  opacity: 0.9,
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: SvgPicture.asset(
                                      'assets/icons/fire.svg',
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: LumiSpacingTokens.space2),
                          _ProjectMetaLine(data: data),
                        ],
                      ),
                    ),
                    const SizedBox(width: LumiSpacingTokens.space7),
                    _ProjectTrailingStatus(data: data),
                  ],
                ),
                if (data.overdueCount != null) ...[
                  const SizedBox(height: LumiSpacingTokens.space8),
                  _ProjectOverdueBlock(
                    key: Key('space-overdue-${data.id}'),
                    count: data.overdueCount!,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectMetaLine extends StatelessWidget {
  const _ProjectMetaLine({required this.data});

  final _ProjectCardData data;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final textTheme = context.lumiTextTheme;
    final metaStyle = textTheme.bodySmall?.copyWith(
      fontSize: LumiTypographyTokens.small.fontSize,
      height: LumiTypographyTokens.small.height,
      letterSpacing: LumiTypographyTokens.small.letterSpacing,
      fontWeight: LumiTypographyTokens.medium,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _MetaPair(
          widgetKey: Key('space-open-count-${data.id}'),
          count: '${data.openCount}',
          label: 'open',
          style: metaStyle,
          countColor: colors.contentPrimary,
          labelColor: _focusSpacesMetricsSecondary,
        ),
        const SizedBox(width: LumiSpacingTokens.space3),
        const _MetaDivider(),
        const SizedBox(width: LumiSpacingTokens.space3),
        _MetaPair(
          widgetKey: Key('space-due-today-count-${data.id}'),
          count: '${data.dueTodayCount}',
          label: 'due today',
          style: metaStyle,
          countColor: colors.contentPrimary,
          labelColor: _focusSpacesMetricsSecondary,
        ),
      ],
    );
  }
}

class _MetaPair extends StatelessWidget {
  const _MetaPair({
    this.widgetKey,
    required this.count,
    required this.label,
    required this.style,
    required this.countColor,
    required this.labelColor,
  });

  final Key? widgetKey;
  final String count;
  final String label;
  final TextStyle? style;
  final Color countColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: widgetKey,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          count,
          style: style?.copyWith(
            color: countColor,
            fontWeight: LumiTypographyTokens.medium,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: style?.copyWith(
            color: labelColor,
            fontWeight: LumiTypographyTokens.medium,
          ),
        ),
      ],
    );
  }
}

class _MetaDivider extends StatelessWidget {
  const _MetaDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 1,
      decoration: BoxDecoration(
        color: const Color(0xFFD3D2CF),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _ProjectTrailingStatus extends StatelessWidget {
  const _ProjectTrailingStatus({required this.data});

  final _ProjectCardData data;

  @override
  Widget build(BuildContext context) {
    return _ProgressRing(
      progressKey: Key('space-progress-${data.id}'),
      progressLabel: 'space-progress-${data.id}',
      progressValue: '${data.completedCount}/${data.totalCount}',
      completedCount: data.completedCount,
      totalCount: data.totalCount,
    );
  }
}

class _ProjectOverdueBlock extends StatelessWidget {
  const _ProjectOverdueBlock({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final textTheme = context.lumiTextTheme;
    final overdueStyle = textTheme.bodySmall?.copyWith(
      fontSize: LumiTypographyTokens.small.fontSize,
      height: LumiTypographyTokens.small.height,
      letterSpacing: LumiTypographyTokens.small.letterSpacing,
      fontWeight: LumiTypographyTokens.medium,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: LumiSpacingTokens.space7,
        vertical: LumiSpacingTokens.space6,
      ),
      decoration: BoxDecoration(
        color: colors.appBackground,
        borderRadius: BorderRadius.circular(LumiSpacingTokens.space2),
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: overdueStyle?.copyWith(
                  color: colors.contentSecondary,
                  fontWeight: LumiTypographyTokens.medium,
                ),
                children: [
                  TextSpan(
                    text: '$count',
                    style: overdueStyle?.copyWith(
                      color: colors.contentPrimary,
                      fontWeight: LumiTypographyTokens.medium,
                    ),
                  ),
                  const TextSpan(text: ' overdue'),
                ],
              ),
            ),
          ),
          SvgPicture.asset(
            'assets/icons/maximize.svg',
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              colors.contentSecondary,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({
    required this.progressKey,
    required this.progressLabel,
    required this.progressValue,
    required this.completedCount,
    required this.totalCount,
  });

  final Key progressKey;
  final String progressLabel;
  final String progressValue;
  final int completedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final safeProgress = totalCount <= 0
        ? 0.0
        : (completedCount / totalCount).clamp(0.0, 1.0);

    return Semantics(
      key: progressKey,
      label: progressLabel,
      value: progressValue,
      child: _AnimatedProgressRing(progress: safeProgress),
    );
  }
}

class _AnimatedProgressRing extends StatefulWidget {
  const _AnimatedProgressRing({required this.progress});

  final double progress;

  @override
  State<_AnimatedProgressRing> createState() => _AnimatedProgressRingState();
}

class _AnimatedProgressRingState extends State<_AnimatedProgressRing> {
  late double _fromProgress;
  late double _toProgress;

  @override
  void initState() {
    super.initState();
    final initialProgress = widget.progress.clamp(0.0, 1.0);
    _fromProgress = initialProgress;
    _toProgress = initialProgress;
  }

  @override
  void didUpdateWidget(covariant _AnimatedProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextProgress = widget.progress.clamp(0.0, 1.0);
    if (nextProgress != _toProgress) {
      _fromProgress = _toProgress;
      _toProgress = nextProgress;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: _fromProgress, end: _toProgress),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (context, animatedProgress, child) {
        return SizedBox(
          width: _focusSpacesRingSize,
          height: _focusSpacesRingSize,
          child: CustomPaint(
            painter: _ProgressRingPainter(
              progress: animatedProgress,
              trackColor: const Color(0x80DAD9D7),
            ),
          ),
        );
      },
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  const _ProgressRingPainter({
    required this.progress,
    required this.trackColor,
  });

  final double progress;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 1.6;
    final rect = Offset.zero & size;
    final startAngle = -math.pi / 2;
    final clampedProgress = progress.clamp(0.0, 1.0);
    final sweepAngle = math.pi * 2 * clampedProgress;
    final arcRect = rect.deflate(strokeWidth / 2);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(arcRect, 0, math.pi * 2, false, trackPaint);
    if (sweepAngle > 0.0001) {
      final denseStop = (clampedProgress * 0.58).clamp(0.0, clampedProgress);
      progressPaint.shader = SweepGradient(
        transform: GradientRotation(startAngle),
        colors: const [
          Color(0xFFFD6116),
          Color(0xFFFD6116),
          Color(0x00FD6116),
          Color(0x00FD6116),
        ],
        stops: [0.0, denseStop, clampedProgress, 1.0],
      ).createShader(rect);

      canvas.drawArc(arcRect, startAngle, sweepAngle, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        trackColor != oldDelegate.trackColor;
  }
}

class _DashedCirclePainter extends CustomPainter {
  const _DashedCirclePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    final rect = Offset.zero & size;
    const dashCount = 20;
    const gapFactor = 0.55;
    final sweep = (math.pi * 2) / dashCount;
    final dashSweep = sweep * gapFactor;

    for (var index = 0; index < dashCount; index++) {
      final start = (-math.pi / 2) + (sweep * index);
      canvas.drawArc(rect.deflate(2), start, dashSweep, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) {
    return color != oldDelegate.color;
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

class _ProjectCardData {
  const _ProjectCardData({
    required this.id,
    required this.title,
    required this.openCount,
    required this.dueTodayCount,
    required this.completedCount,
    required this.totalCount,
    this.overdueCount,
    this.pinned = false,
  });

  factory _ProjectCardData.fromSummary(LumiSpaceSummary summary) {
    return _ProjectCardData(
      id: summary.id,
      title: summary.name,
      openCount: summary.openTasks,
      dueTodayCount: summary.dueTodayTasks,
      completedCount: summary.completedTasks,
      totalCount: summary.totalTasks,
      overdueCount: summary.overdueTasks == 0 ? null : summary.overdueTasks,
      pinned: summary.isPinned,
    );
  }

  final String id;
  final String title;
  final int openCount;
  final int dueTodayCount;
  final int completedCount;
  final int totalCount;
  final int? overdueCount;
  final bool pinned;
}
