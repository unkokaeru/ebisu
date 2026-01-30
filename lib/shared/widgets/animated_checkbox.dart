import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ebisu/core/configuration/numeric_constants.dart';

class AnimatedCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;

  const AnimatedCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: NumericConstants.animationDurationFast),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: value
              ? (activeColor ?? Theme.of(context).colorScheme.primary)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusSmall),
          border: Border.all(
            color: value
                ? (activeColor ?? Theme.of(context).colorScheme.primary)
                : Theme.of(context).colorScheme.outline,
            width: 2,
          ),
        ),
        child: value
            ? const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 20,
              )
                .animate()
                .scale(
                  begin: const Offset(0, 0),
                  end: const Offset(1, 1),
                  duration: const Duration(milliseconds: NumericConstants.animationDurationFast),
                  curve: Curves.elasticOut,
                )
            : null,
      ),
    );
  }
}
