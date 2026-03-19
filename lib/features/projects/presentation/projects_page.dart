import 'package:flutter/material.dart';
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
            Text(
              'Projects',
              key: const Key('projects-page-title'),
              style: textTheme.displaySmall?.copyWith(
                color: colors.contentPrimary,
              ),
            ),
            SizedBox(height: insets.sectionGap),
            Container(
              width: double.infinity,
              padding: insets.cardPadding,
              decoration: BoxDecoration(
                color: colors.surfaceSecondary,
                borderRadius: shapes.panel,
                border: Border.all(color: colors.borderSecondary),
              ),
              child: Text(
                'Projects destination placeholder is wired into the root shell.',
                style: textTheme.bodyLarge?.copyWith(
                  color: colors.contentSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
