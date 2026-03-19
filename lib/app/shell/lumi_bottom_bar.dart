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

    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfacePrimary,
          border: Border(top: BorderSide(color: colors.borderSecondary)),
        ),
        child: Padding(
          padding: insets.bottomBarPadding,
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: insets.clusterGap,
                    runSpacing: insets.clusterGap,
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
                        label: 'Projects',
                        selected: _isProjectsSelected,
                        onTap: () => context.go(ProjectsPage.routePath),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Wrap(
                    spacing: insets.clusterGap,
                    runSpacing: insets.clusterGap,
                    children: const [
                      _ActionItem(
                        icon: CupertinoIcons.plus_circle_fill,
                        label: 'Add Text Task',
                      ),
                      _ActionItem(
                        icon: CupertinoIcons.mic_fill,
                        label: 'Add Voice Task',
                      ),
                    ],
                  ),
                ),
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
    final colors = context.lumiColors;
    final insets = context.lumiInsets;
    final shapes = context.lumiShapes;
    final textTheme = context.lumiTextTheme;

    final foregroundColor = selected
        ? colors.contentPrimary
        : colors.contentSecondary;
    final backgroundColor = selected
        ? colors.surfaceSecondary
        : colors.surfaceGhost;
    final borderColor = selected ? colors.borderPrimary : colors.borderTertiary;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: shapes.pill,
        onTap: onTap,
        child: Container(
          padding: insets.pillPadding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: shapes.pill,
            border: Border.all(color: borderColor),
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
    final textTheme = context.lumiTextTheme;

    return Container(
      padding: insets.pillPadding,
      decoration: BoxDecoration(
        color: colors.surfaceSecondary,
        borderRadius: shapes.pill,
        border: Border.all(color: colors.borderSecondary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: colors.contentPrimary),
          SizedBox(width: insets.itemGap),
          Text(
            label,
            style: textTheme.labelLarge?.copyWith(color: colors.contentPrimary),
          ),
        ],
      ),
    );
  }
}
