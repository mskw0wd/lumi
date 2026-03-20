import 'package:flutter/material.dart';
import 'package:lumi/design_system/primitives/lumi_primary_button.dart';
import 'package:lumi/design_system/primitives/lumi_text.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';

class LumiStateView extends StatelessWidget {
  const LumiStateView({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? message;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final insets = context.lumiInsets;

    return Center(
      child: Padding(
        padding: insets.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon case final value) ...[
              Icon(value, size: insets.iconSize, color: colors.contentTertiary),
              SizedBox(height: insets.itemGap),
            ],
            LumiText(
              title,
              role: LumiTextRole.titleMedium,
              tone: LumiTextTone.primary,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              SizedBox(height: insets.clusterGap),
              LumiText(
                message!,
                role: LumiTextRole.bodySmall,
                tone: LumiTextTone.tertiary,
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null) ...[
              SizedBox(height: insets.sectionGap),
              LumiPrimaryButton(label: actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}
