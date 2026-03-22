import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumi/app/overlays/app_overlay_controller.dart';
import 'package:lumi/design_system/components/lumi_composer_container.dart';
import 'package:lumi/design_system/components/lumi_sheet_container.dart';
import 'package:lumi/design_system/motion/lumi_motion.dart';
import 'package:lumi/design_system/primitives/lumi_icon_button.dart';
import 'package:lumi/design_system/primitives/lumi_primary_button.dart';
import 'package:lumi/design_system/primitives/lumi_text.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';
import 'package:lumi/features/quick_add/presentation/quick_add_composer.dart';
import 'package:lumi/features/tasks/application/lumi_task_store.dart';

class AppOverlayHost extends ConsumerWidget {
  const AppOverlayHost({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(appOverlayControllerProvider);

    return IgnorePointer(
      ignoring: entry == null,
      child: AnimatedSwitcher(
        duration: LumiMotion.fadeScale.duration,
        reverseDuration: LumiMotion.fadeScale.reverseDuration,
        switchInCurve: LumiMotion.fadeScale.curve,
        switchOutCurve:
            LumiMotion.fadeScale.reverseCurve ?? LumiMotion.fadeScale.curve,
        transitionBuilder: (child, animation) {
          final curve = CurvedAnimation(
            parent: animation,
            curve: LumiMotion.fadeScale.curve,
            reverseCurve:
                LumiMotion.fadeScale.reverseCurve ?? LumiMotion.fadeScale.curve,
          );

          return FadeTransition(
            opacity: curve,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.02),
                end: Offset.zero,
              ).animate(curve),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.985, end: 1).animate(curve),
                child: child,
              ),
            ),
          );
        },
        child: entry == null
            ? const SizedBox.shrink(key: ValueKey('overlay-empty'))
            : _OverlayStage(key: ValueKey(entry.kind), entry: entry),
      ),
    );
  }
}

class _OverlayStage extends ConsumerWidget {
  const _OverlayStage({super.key, required this.entry});

  final AppOverlayEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: ref.read(appOverlayControllerProvider.notifier).dismiss,
          child: const SizedBox.expand(),
        ),
        _buildContainer(context, ref),
      ],
    );
  }

  Widget _buildContainer(BuildContext context, WidgetRef ref) {
    final controller = ref.read(appOverlayControllerProvider.notifier);
    final taskStore = ref.read(lumiTasksProvider.notifier);
    final focusDate = ref.read(lumiFocusDateProvider);

    return switch (entry.kind) {
      AppOverlayKind.quickAdd => LumiComposerContainer(
        child: QuickAddComposer(
          onDismiss: controller.dismiss,
          onProjectTap: controller.showProjectPicker,
          onTodayTap: controller.showCalendar,
          onSubmit: (value) {
            final task = taskStore.createTask(title: value, dueDate: focusDate);
            if (task != null) {
              controller.dismiss();
            }
          },
        ),
      ),
      AppOverlayKind.calendar => LumiSheetContainer(
        child: _OverlayPlaceholderContent(
          title: 'Calendar foundation',
          message:
              'Bottom sheet host is wired. Date selection will be added later.',
          icon: CupertinoIcons.calendar,
          onDismiss: controller.dismiss,
          trailing: LumiIconButton(
            icon: CupertinoIcons.xmark,
            tooltip: 'Dismiss calendar',
            onPressed: controller.dismiss,
          ),
        ),
      ),
      AppOverlayKind.projectPicker => LumiSheetContainer(
        child: _OverlayPlaceholderContent(
          title: 'Project picker foundation',
          message:
              'Project picker host is wired. Actual project list lands in the next step.',
          icon: CupertinoIcons.folder,
          onDismiss: controller.dismiss,
          trailing: LumiIconButton(
            icon: CupertinoIcons.xmark,
            tooltip: 'Dismiss project picker',
            onPressed: controller.dismiss,
          ),
        ),
      ),
      AppOverlayKind.voice => LumiSheetContainer(
        child: _OverlayPlaceholderContent(
          title: 'Voice foundation',
          message:
              'Voice layer slot is ready. Capture and parsing stay out of this step.',
          icon: CupertinoIcons.mic,
          onDismiss: controller.dismiss,
          trailing: LumiIconButton(
            icon: CupertinoIcons.xmark,
            tooltip: 'Dismiss voice',
            onPressed: controller.dismiss,
          ),
        ),
      ),
    };
  }
}

class _OverlayPlaceholderContent extends StatelessWidget {
  const _OverlayPlaceholderContent({
    required this.title,
    required this.message,
    required this.icon,
    required this.onDismiss,
    required this.trailing,
  });

  final String title;
  final String message;
  final IconData icon;
  final VoidCallback onDismiss;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final insets = context.lumiInsets;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: insets.iconSize, color: colors.contentSecondary),
            SizedBox(width: insets.itemGap),
            Expanded(
              child: LumiText(
                title,
                role: LumiTextRole.titleMedium,
                tone: LumiTextTone.primary,
              ),
            ),
            trailing,
          ],
        ),
        SizedBox(height: insets.itemGap),
        LumiText(
          message,
          role: LumiTextRole.bodySmall,
          tone: LumiTextTone.tertiary,
        ),
        SizedBox(height: insets.sectionGap),
        LumiPrimaryButton(label: 'Dismiss', onPressed: onDismiss),
      ],
    );
  }
}
