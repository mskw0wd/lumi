import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';
import 'package:lumi/features/inbox/presentation/inbox_page.dart';
import 'package:lumi/features/projects/presentation/projects_page.dart';

class LumiBottomBar extends StatelessWidget {
  const LumiBottomBar({super.key, required this.currentLocation});

  final String currentLocation;

  bool get _isInboxSelected => currentLocation.startsWith(InboxPage.routePath);
  bool get _isProjectsSelected =>
      currentLocation.startsWith(ProjectsPage.routePath);

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final insets = context.lumiInsets;
    final shapes = context.lumiShapes;

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
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surfaceTertiary,
            borderRadius: shapes.bar,
          ),
          child: Padding(
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
                  children: const [
                    _ActionItem(
                      icon: CupertinoIcons.add,
                      label: 'Add Text Task',
                    ),
                    _ActionItem(
                      icon: CupertinoIcons.mic_fill,
                      label: 'Add Voice Task',
                    ),
                  ],
                ),
              ],
            ),
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
    final colors = context.lumiColors;
    final insets = context.lumiInsets;
    final shapes = context.lumiShapes;
    final textTheme = context.lumiTextTheme;

    final foregroundColor = selected
        ? colors.contentInverse
        : colors.contentSecondary;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: shapes.pill,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          padding: insets.pillPadding,
          decoration: BoxDecoration(
            color: selected ? colors.surfaceInverse : colors.surfaceGhost,
            borderRadius: shapes.pill,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: foregroundColor),
              SizedBox(width: insets.itemGap),
              Text(
                label,
                style: textTheme.labelLarge?.copyWith(color: foregroundColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final insets = context.lumiInsets;
    final shapes = context.lumiShapes;

    return Tooltip(
      message: label,
      child: Container(
        padding: insets.pillPadding,
        decoration: BoxDecoration(
          color: colors.surfaceInverse,
          borderRadius: shapes.pill,
        ),
        child: Icon(icon, color: colors.contentInverse),
      ),
    );
  }
}
