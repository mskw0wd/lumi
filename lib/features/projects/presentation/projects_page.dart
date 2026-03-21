import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';
import 'package:lumi/design_system/tokens/lumi_spacing_tokens.dart';
import 'package:lumi/design_system/tokens/lumi_typography_tokens.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  static const routeName = 'projects';
  static const routePath = '/projects';

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final insets = context.lumiInsets;
    final shapes = context.lumiShapes;
    final textTheme = context.lumiTextTheme;

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
                        ),
                      ),
                      SizedBox(height: insets.clusterGap),
                      Text(
                        'Projects keep your work in motion.',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Projects',
                    key: const Key('projects-page-title'),
                    style: textTheme.displayLarge?.copyWith(
                      color: colors.contentPrimary,
                    ),
                  ),
                  const SizedBox(height: LumiSpacingTokens.space3),
                  Text(
                    'Organize tasks into focused spaces.',
                    style: textTheme.displayLarge?.copyWith(
                      color: colors.contentSecondary,
                    ),
                  ),
                  const SizedBox(height: LumiSpacingTokens.space3_1),
                  RichText(
                    text: TextSpan(
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.contentSecondary,
                        fontWeight: LumiTypographyTokens.medium,
                      ),
                      children: [
                        TextSpan(
                          text: '3 projects',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.contentPrimary,
                            fontWeight: LumiTypographyTokens.medium,
                          ),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: 'ready for focus',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.contentSecondary,
                            fontWeight: LumiTypographyTokens.medium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: LumiSpacingTokens.space12),
                  Expanded(
                    child: Container(
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
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        children: const [
                          _ProjectPlaceholderRow(
                            title: 'Lumi',
                            subtitle: 'Foundation setup',
                          ),
                          _ProjectPlaceholderRow(
                            title: 'ICVR',
                            subtitle: 'Onboarding flow',
                          ),
                          _ProjectPlaceholderRow(
                            title: 'Coinask',
                            subtitle: 'Calendar and reminders',
                          ),
                          _ProjectPlaceholderRow(
                            title: 'LevelLegends',
                            subtitle: 'API review',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectPlaceholderRow extends StatelessWidget {
  const _ProjectPlaceholderRow({required this.title, required this.subtitle});

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
