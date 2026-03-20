import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lumi/design_system/motion/lumi_motion.dart';
import 'package:lumi/design_system/primitives/lumi_text_field.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';
import 'package:lumi/design_system/tokens/lumi_spacing_tokens.dart';

class QuickAddComposer extends StatefulWidget {
  const QuickAddComposer({
    super.key,
    required this.onSubmit,
    required this.onDismiss,
    required this.onProjectTap,
    required this.onTodayTap,
  });

  final ValueChanged<String> onSubmit;
  final VoidCallback onDismiss;
  final VoidCallback onProjectTap;
  final VoidCallback onTodayTap;

  @override
  State<QuickAddComposer> createState() => _QuickAddComposerState();
}

class _QuickAddComposerState extends State<QuickAddComposer> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _controller.addListener(_handleTextChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    final nextValue = _controller.text.trim().isNotEmpty;

    if (nextValue == _canSubmit) {
      return;
    }

    setState(() {
      _canSubmit = nextValue;
    });
  }

  void _handleSubmit(String value) {
    final text = value.trim();

    if (text.isEmpty) {
      widget.onDismiss();
      return;
    }

    widget.onSubmit(text);
  }

  void _submitCurrentValue() {
    _handleSubmit(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final insets = context.lumiInsets;

    return Column(
      key: const Key('quick-add-composer'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: insets.controlMinHeight + insets.itemGap,
                ),
                child: LumiTextField(
                  key: const Key('quick-add-field'),
                  controller: _controller,
                  focusNode: _focusNode,
                  autofocus: true,
                  hintText: 'What would you like to do?',
                  minLines: 1,
                  maxLines: 6,
                  textInputAction: TextInputAction.done,
                  onSubmitted: _handleSubmit,
                  variant: LumiTextFieldVariant.composer,
                ),
              ),
            ),
            SizedBox(width: insets.screenHorizontal),
            _QuickAddSubmitButton(
              enabled: _canSubmit,
              onPressed: _canSubmit ? _submitCurrentValue : null,
            ),
          ],
        ),
        SizedBox(height: insets.itemGap),
        Row(
          children: [
            _QuickAddChip(
              onTap: widget.onProjectTap,
              icon: CupertinoIcons.plus_square,
              label: 'Project',
            ),
            const SizedBox(width: LumiSpacingTokens.space3),
            _QuickAddChip(
              onTap: widget.onTodayTap,
              icon: CupertinoIcons.calendar,
              label: 'Today',
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAddChip extends StatelessWidget {
  const _QuickAddChip({
    required this.onTap,
    required this.icon,
    required this.label,
  });

  final VoidCallback onTap;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final textTheme = context.lumiTextTheme;
    final shapes = context.lumiShapes;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: shapes.pill,
        onTap: onTap,
        child: Container(
          height: 42,
          padding: const EdgeInsets.fromLTRB(
            LumiSpacingTokens.space7,
            LumiSpacingTokens.space5,
            LumiSpacingTokens.space8,
            LumiSpacingTokens.space5,
          ),
          decoration: BoxDecoration(
            borderRadius: shapes.pill,
            border: Border.all(color: colors.borderSecondary),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: colors.contentPrimary),
              const SizedBox(width: LumiSpacingTokens.space3),
              Text(
                label,
                style: textTheme.labelLarge?.copyWith(
                  color: colors.contentPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAddSubmitButton extends StatelessWidget {
  const _QuickAddSubmitButton({required this.enabled, this.onPressed});

  final bool enabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.lumiColors;
    final insets = context.lumiInsets;
    final shapes = context.lumiShapes;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        key: const Key('quick-add-submit'),
        borderRadius: shapes.pill,
        onTap: onPressed,
        child: SizedBox(
          width: insets.controlMinHeight + insets.itemGap,
          height: insets.controlMinHeight + insets.itemGap,
          child: Center(
            child: AnimatedScale(
              duration: LumiMotion.tap.duration,
              curve: LumiMotion.tap.curve,
              scale: enabled ? 1 : 0.94,
              child: AnimatedOpacity(
                duration: LumiMotion.tap.duration,
                curve: LumiMotion.tap.curve,
                opacity: enabled ? 1 : 0.35,
                child: Icon(
                  CupertinoIcons.add,
                  size: insets.screenHorizontal,
                  color: colors.contentPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
