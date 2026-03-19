import 'package:flutter/cupertino.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  static const routeName = 'inbox';
  static const routePath = '/inbox';

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
                        'Hey, Max',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.contentTertiary,
                        ),
                      ),
                      SizedBox(height: insets.clusterGap),
                      Text(
                        'Ready to start the day?',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.contentTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  CupertinoIcons.cube_box,
                  color: colors.contentTertiary,
                  size: 22,
                ),
              ],
            ),
            SizedBox(height: insets.sectionGap + insets.itemGap),
            Text(
              'Today',
              key: const Key('inbox-page-title'),
              style: textTheme.displayLarge?.copyWith(
                color: colors.contentPrimary,
              ),
            ),
            SizedBox(height: insets.clusterGap),
            Text(
              'Tue, March 16',
              style: textTheme.displayLarge?.copyWith(
                color: colors.contentTertiary,
              ),
            ),
            SizedBox(height: insets.itemGap),
            RichText(
              text: TextSpan(
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.contentTertiary,
                ),
                children: [
                  TextSpan(
                    text: '7 tasks ',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.contentSecondary,
                    ),
                  ),
                  const TextSpan(text: 'to focus on'),
                ],
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
                    _InboxPlaceholderRow(
                      title: 'Refine shell rhythm and spacing',
                      subtitle: 'Foundation',
                    ),
                    _InboxPlaceholderRow(
                      title: 'Align calendar entrypoint with header',
                      subtitle: 'Next step',
                      emphasized: true,
                    ),
                    _InboxPlaceholderRow(
                      title: 'Prepare root overlay anchor point',
                      subtitle: 'Later',
                    ),
                    _InboxPlaceholderRow(
                      title: 'Validate empty state composition',
                      subtitle: 'Shell',
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

class _InboxPlaceholderRow extends StatelessWidget {
  const _InboxPlaceholderRow({
    required this.title,
    required this.subtitle,
    this.emphasized = false,
  });

  final String title;
  final String subtitle;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final insets = context.lumiInsets;
    final textTheme = context.lumiTextTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: insets.clusterGap),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(CupertinoIcons.square, color: colors.borderTertiary, size: 20),
          SizedBox(width: insets.itemGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodyMedium?.copyWith(
                    color: emphasized
                        ? colors.contentPrimary
                        : colors.contentTertiary,
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
          if (emphasized)
            Icon(
              CupertinoIcons.arrow_clockwise_circle,
              color: colors.statusDanger,
            ),
        ],
      ),
    );
  }
}
