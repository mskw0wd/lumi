import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumi/app/overlays/app_overlay_controller.dart';
import 'package:lumi/design_system/motion/lumi_motion.dart';
import 'package:lumi/design_system/primitives/lumi_icon_button.dart';
import 'package:lumi/design_system/primitives/lumi_surface.dart';
import 'package:lumi/design_system/primitives/lumi_text.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';
import 'package:lumi/features/inbox/presentation/inbox_page.dart';
import 'package:lumi/features/projects/presentation/projects_page.dart';

class LumiBottomBar extends ConsumerWidget {
  const LumiBottomBar({super.key, required this.currentLocation});

  final String currentLocation;

  bool get _isInboxSelected => currentLocation.startsWith(InboxPage.routePath);
  bool get _isProjectsSelected =>
      currentLocation.startsWith(ProjectsPage.routePath);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insets = context.lumiInsets;
    final overlayController = ref.read(appOverlayControllerProvider.notifier);

    return SafeArea(
      top: false,
      minimum: EdgeInsets.fromLTRB(
        insets.screenHorizontal,
        insets.clusterGap,
        insets.screenHorizontal,
        insets.clusterGap,
      ),
      child: Padding(
        padding: EdgeInsets.only(top: insets.clusterGap),
        child: LumiSurface(
          tone: LumiSurfaceTone.tertiary,
          shape: LumiSurfaceShape.bar,
          padding: EdgeInsets.symmetric(
            horizontal: insets.clusterGap,
            vertical: insets.clusterGap,
          ),
          child: Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: insets.clusterGap,
                  runSpacing: insets.clusterGap,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _NavigationItem(
                      key: const Key('bottom-bar-inbox'),
                      icon: CupertinoIcons.tray_fill,
                      label: 'Inbox',
                      selected: _isInboxSelected,
                      onTap: () => context.go(InboxPage.routePath),
                    ),
                    _NavigationItem(
                      key: const Key('bottom-bar-projects'),
                      icon: CupertinoIcons.square_grid_2x2_fill,
                      label: 'Project',
                      selected: _isProjectsSelected,
                      onTap: () => context.go(ProjectsPage.routePath),
                    ),
                  ],
                ),
              ),
              Wrap(
                spacing: insets.clusterGap,
                runSpacing: insets.clusterGap,
                children: [
                  LumiIconButton(
                    icon: CupertinoIcons.add,
                    tooltip: 'Add Text Task',
                    tone: LumiIconButtonTone.inverse,
                    onPressed: overlayController.showQuickAdd,
                  ),
                  LumiIconButton(
                    icon: CupertinoIcons.mic_fill,
                    tooltip: 'Add Voice Task',
                    tone: LumiIconButtonTone.inverse,
                    onPressed: overlayController.showVoice,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final insets = context.lumiInsets;
    final colors = context.lumiColors;

    final foregroundColor = selected
        ? colors.contentInverse
        : colors.contentSecondary;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: context.lumiShapes.pill,
        onTap: onTap,
        child: AnimatedContainer(
          duration: LumiMotion.tap.duration,
          curve: LumiMotion.tap.curve,
          child: LumiSurface(
            tone: selected ? LumiSurfaceTone.inverse : LumiSurfaceTone.ghost,
            shape: LumiSurfaceShape.pill,
            padding: insets.pillPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: foregroundColor, size: insets.iconSize),
                SizedBox(width: insets.itemGap),
                LumiText(
                  label,
                  role: LumiTextRole.labelLarge,
                  tone: selected
                      ? LumiTextTone.inverse
                      : LumiTextTone.secondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
