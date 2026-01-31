import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ebisu/core/configuration/numeric_constants.dart';
import 'package:ebisu/core/configuration/color_constants.dart';

class ExperienceProgressBar extends StatelessWidget {
  final double progress;
  final int currentExperience;
  final int targetExperience;
  final bool showLabels;
  final double height;

  const ExperienceProgressBar({
    super.key,
    required this.progress,
    required this.currentExperience,
    required this.targetExperience,
    this.showLabels = true,
    this.height = NumericConstants.progressBarHeight,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: Stack(
            children: [
              Container(
                height: height,
                width: double.infinity,
                color: isDark
                    ? ColorConstants.experienceBarEmptyDark
                    : ColorConstants.experienceBarEmpty,
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: NumericConstants.animationDurationMedium),
                curve: Curves.easeOutCubic,
                height: height,
                width: double.infinity,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          isDark
                              ? ColorConstants.experienceBarFilledDark
                              : ColorConstants.experienceBarFilled,
                          isDark
                              ? ColorConstants.experienceBarFilledDark.withOpacity(0.8)
                              : ColorConstants.experienceBarFilled.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ).animate().shimmer(
              duration: const Duration(seconds: 2),
              delay: const Duration(milliseconds: 500),
            ),
        if (showLabels) ...[
          const SizedBox(height: NumericConstants.paddingTiny),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$currentExperience XP',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '$targetExperience XP',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ],
    );
  }
}
