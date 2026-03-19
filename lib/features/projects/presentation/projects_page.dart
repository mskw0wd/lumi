import 'package:flutter/cupertino.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';

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
      child: Padding(
        padding: insets.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Workspace',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.contentTertiary,
                        ),
                      ),
                      SizedBox(height: insets.clusterGap),
                      Text(
                        'Organize work into focused spaces.',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.contentTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  CupertinoIcons.square_grid_2x2,
                  color: colors.contentTertiary,
                  size: 22,
                ),
              ],
            ),
            SizedBox(height: insets.sectionGap + insets.itemGap),
            Text(
              'Projects',
              key: const Key('projects-page-title'),
              style: textTheme.displayLarge?.copyWith(
                color: colors.contentPrimary,
              ),
            ),
            SizedBox(height: insets.clusterGap),
            Text(
              'Create structure without leaving the grounded shell.',
              style: textTheme.bodyLarge?.copyWith(
                color: colors.contentSecondary,
              ),
            ),
            SizedBox(height: insets.sectionGap + insets.itemGap),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: insets.cardPadding,
                decoration: BoxDecoration(
                  color: colors.surfaceSecondary,
                  borderRadius: shapes.panel,
                  border: Border.all(color: colors.borderTertiary),
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: const [
                    _ProjectPlaceholderRow(
                      title: 'Lumi App',
                      subtitle: 'Foundation setup',
                    ),
                    _ProjectPlaceholderRow(
                      title: 'iOS-first polish',
                      subtitle: 'Design system',
                    ),
                    _ProjectPlaceholderRow(
                      title: 'MVP rollout',
                      subtitle: 'Execution order',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
    final insets = context.lumiInsets;
    final shapes = context.lumiShapes;
    final textTheme = context.lumiTextTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: insets.clusterGap),
      child: Container(
        width: double.infinity,
        padding: insets.cardPadding,
        decoration: BoxDecoration(
          color: colors.surfacePrimary,
          borderRadius: shapes.panel,
          border: Border.all(color: colors.borderTertiary),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.bodyLarge?.copyWith(
                color: colors.contentPrimary,
              ),
            ),
            SizedBox(height: insets.clusterGap),
            Text(
              subtitle,
              style: textTheme.bodySmall?.copyWith(
                color: colors.contentTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
