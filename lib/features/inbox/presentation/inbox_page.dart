import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lumi/app/overlays/app_overlay_controller.dart';
import 'package:lumi/features/tasks/application/lumi_task_store.dart';
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
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final overlayController = ref.read(appOverlayControllerProvider.notifier);
    final focusCount = ref.watch(inboxFocusCountProvider);
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
          final footerClearance =
              44 +
              (insets.cardPaddingValue * 2) +
              bottomInset +
              LumiSpacingTokens.space5;

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
                            focusCount: focusCount,
                          ),
                          SizedBox(height: listSpacing),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: footerClearance),
                              child: child!,
                            ),
                          ),
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

class _InboxTaskRow extends StatelessWidget {
  const _InboxTaskRow({required this.task, required this.onToggle});

  final LumiInboxTaskItem task;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final textTheme = context.lumiTextTheme;
    final titleColor = task.isCompleted
        ? colors.contentSecondary
        : colors.contentPrimary;
    final subtitleColor = task.isCompleted
        ? colors.contentTertiary
        : colors.contentSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: LumiSpacingTokens.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            key: Key('inbox-task-checkbox-${task.id}'),
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: task.isCompleted
                    ? colors.contentPrimary
                    : Colors.transparent,
                border: Border.all(
                  color: task.isCompleted
                      ? colors.contentPrimary
                      : colors.borderTertiary,
                  width: 1.25,
                ),
              ),
              child: task.isCompleted
                  ? Center(
                      child: Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: colors.surfacePrimary,
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: LumiSpacingTokens.space7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: textTheme.bodyMedium?.copyWith(
                    color: titleColor,
                    fontWeight: LumiTypographyTokens.medium,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: subtitleColor,
                  ),
                ),
                const SizedBox(height: LumiSpacingTokens.space2),
                Text(
                  task.subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: subtitleColor,
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
    required this.focusCount,
  });

  final String relativeDateLabel;
  final String absoluteDateLabel;
  final TextStyle? dateStyle;
  final VoidCallback onTap;
  final double collapseProgress;
  final int focusCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final textTheme = context.lumiTextTheme;
    final todayProgress = (collapseProgress / 0.65).clamp(0.0, 1.0);
    final summaryProgress = (collapseProgress / 0.85).clamp(0.0, 1.0);
    final summaryShift = lerpDouble(0, -2, summaryProgress)!;
    final summaryOpacity = lerpDouble(1, 0.74, summaryProgress)!;
    final focusCountLabel = focusCount == 1 ? '1 task' : '$focusCount tasks';

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
                      text: focusCountLabel,
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

class _TaskPreviewList extends ConsumerWidget {
  const _TaskPreviewList({required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.lumiColors;
    final shapes = context.lumiShapes;
    final tasks = ref.watch(inboxTaskItemsProvider);
    final taskStore = ref.read(lumiTasksProvider.notifier);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: LumiSpacingTokens.space7,
        vertical: LumiSpacingTokens.space3,
      ),
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        borderRadius: shapes.panel,
      ),
      child: ListView.builder(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: LumiSpacingTokens.space9),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return _InboxTaskRow(
            task: task,
            onToggle: () => taskStore.toggleCompletion(task.id),
          );
        },
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
