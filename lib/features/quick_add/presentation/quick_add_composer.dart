import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lumi/design_system/motion/lumi_motion.dart';
import 'package:lumi/design_system/primitives/lumi_text_field.dart';
import 'package:lumi/design_system/theme/lumi_theme_extensions.dart';
import 'package:lumi/design_system/tokens/lumi_spacing_tokens.dart';

const _kQuickAddChipBorderColor = Color(0xFFEBEBEB);
const _kQuickAddFilledActionColor = Color(0xFFFD6116);
const _kQuickAddEmptyActionIconColor = Color(0xFF868686);
const _kQuickAddFilledActionIconColor = Color(0xFFFCFCFC);

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
      return;
    }

    _controller.clear();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: LumiSpacingTokens.space5,
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
              iconAssetPath: 'assets/icons/quick_add_project_chip.svg',
              label: 'Project',
            ),
            const SizedBox(width: LumiSpacingTokens.space3),
            _QuickAddChip(
              onTap: widget.onTodayTap,
              iconAssetPath: 'assets/icons/quick_add_today_chip.svg',
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
    required this.iconAssetPath,
    required this.label,
  });

  final VoidCallback onTap;
  final String iconAssetPath;
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
            LumiSpacingTokens.space3,
            LumiSpacingTokens.space8,
            LumiSpacingTokens.space3,
          ),
          decoration: BoxDecoration(
            borderRadius: shapes.pill,
            border: Border.all(color: _kQuickAddChipBorderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(iconAssetPath, width: 18, height: 18),
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
    final motion = LumiMotion.tap;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        key: const Key('quick-add-submit'),
        borderRadius: BorderRadius.circular(22),
        onTap: onPressed,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: AnimatedScale(
              duration: motion.duration,
              curve: motion.curve,
              scale: enabled ? 1 : 0.97,
              child: AnimatedContainer(
                duration: motion.duration,
                curve: motion.curve,
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: enabled
                      ? _kQuickAddFilledActionColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(enabled ? 22 : 16),
                ),
                child: TweenAnimationBuilder<Color?>(
                  duration: motion.duration,
                  curve: motion.curve,
                  tween: ColorTween(
                    end: enabled
                        ? _kQuickAddFilledActionIconColor
                        : _kQuickAddEmptyActionIconColor,
                  ),
                  builder: (context, iconColor, child) {
                    return AnimatedOpacity(
                      duration: motion.duration,
                      curve: motion.curve,
                      opacity: enabled ? 1 : 0.35,
                      child: SvgPicture.asset(
                        'assets/icons/quick_add_plus.svg',
                        width: 16,
                        height: 16,
                        colorFilter: ColorFilter.mode(
                          iconColor ?? _kQuickAddEmptyActionIconColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
