import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lumi/app/overlays/app_overlay_controller.dart';
import 'package:lumi/design_system/motion/lumi_motion.dart';
import 'package:lumi/design_system/primitives/lumi_text.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';
import 'package:lumi/design_system/tokens/lumi_spacing_tokens.dart';
import 'package:lumi/design_system/tokens/lumi_typography_tokens.dart';
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
    final colors = context.lumiColors;
    final insets = context.lumiInsets;
    final overlayController = ref.read(appOverlayControllerProvider.notifier);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return DecoratedBox(
      decoration: BoxDecoration(color: colors.appBackground),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          insets.screenHorizontal,
          insets.cardPaddingValue,
          insets.screenHorizontal,
          insets.cardPaddingValue + bottomInset,
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  _NavigationItem(
                    key: const Key('bottom-bar-inbox'),
                    assetPath: _isInboxSelected
                        ? 'assets/icons/inbox_pressed.svg'
                        : 'assets/icons/inbox_default.svg',
                    iconSize: 20,
                    label: 'Inbox',
                    selected: _isInboxSelected,
                    onTap: () => context.go(InboxPage.routePath),
                  ),
                  const SizedBox(width: LumiSpacingTokens.space3),
                  _NavigationItem(
                    key: const Key('bottom-bar-projects'),
                    assetPath: _isProjectsSelected
                        ? 'assets/icons/project_pressed.svg'
                        : 'assets/icons/project_default.svg',
                    iconSize: 20,
                    label: 'Project',
                    selected: _isProjectsSelected,
                    onTap: () => context.go(ProjectsPage.routePath),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                _ActionItem(
                  assetPath: 'assets/icons/AddTaskButton.svg',
                  tooltip: 'Add Text Task',
                  onTap: overlayController.showQuickAdd,
                ),
                const SizedBox(width: LumiSpacingTokens.space3),
                _ActionItem(
                  assetPath: 'assets/icons/AddVoiceTaskButton.svg',
                  tooltip: 'Add Voice Task',
                  onTap: overlayController.showVoice,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    super.key,
    required this.assetPath,
    required this.iconSize,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String assetPath;
  final double iconSize;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final shapes = context.lumiShapes;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: shapes.pill,
        onTap: onTap,
        child: AnimatedContainer(
          duration: LumiMotion.tap.duration,
          curve: LumiMotion.tap.curve,
          height: 44,
          padding: const EdgeInsets.symmetric(
            horizontal: LumiSpacingTokens.space9,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? colors.surfacePrimary : colors.surfaceGhost,
            borderRadius: shapes.pill,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(assetPath, width: iconSize, height: iconSize),
              SizedBox(width: LumiSpacingTokens.space3),
              LumiText(
                label,
                role: LumiTextRole.bodyMedium,
                tone: selected ? LumiTextTone.primary : LumiTextTone.secondary,
                fontWeight: LumiTypographyTokens.medium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({
    required this.assetPath,
    required this.tooltip,
    required this.onTap,
  });

  final String assetPath;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final shapes = context.lumiShapes;

    return Tooltip(
      message: tooltip,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: shapes.pill,
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: LumiSpacingTokens.space7,
              vertical: LumiSpacingTokens.space5,
            ),
            decoration: BoxDecoration(
              color: colors.surfacePrimary,
              borderRadius: shapes.pill,
            ),
            child: SvgPicture.asset(assetPath, width: 20, height: 20),
          ),
        ),
      ),
    );
  }
}
