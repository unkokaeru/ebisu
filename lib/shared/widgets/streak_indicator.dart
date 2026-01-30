import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ebisu/core/configuration/numeric_constants.dart';
import 'package:ebisu/core/configuration/color_constants.dart';
import 'package:ebisu/core/configuration/icon_constants.dart';

class StreakIndicator extends StatelessWidget {
  final int streakCount;
  final bool isCompact;

  const StreakIndicator({
    super.key,
    required this.streakCount,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = streakCount > 0;

    if (isCompact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            IconConstants.rpgStreak,
            color: isActive
                ? ColorConstants.streakActive
                : ColorConstants.streakInactive,
            size: NumericConstants.iconSizeMedium,
          )
              .animate(
                onPlay: (controller) =>
                    isActive ? controller.repeat(reverse: true) : null,
              )
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.15, 1.15),
                duration: const Duration(milliseconds: 600),
              ),
          const SizedBox(width: NumericConstants.paddingTiny),
          Text(
            '$streakCount',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isActive
                      ? ColorConstants.streakActive
                      : ColorConstants.streakInactive,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: NumericConstants.paddingMedium,
        vertical: NumericConstants.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? ColorConstants.streakActive.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
        border: Border.all(
          color: isActive
              ? ColorConstants.streakActive.withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            IconConstants.rpgStreak,
            color: isActive
                ? ColorConstants.streakActive
                : ColorConstants.streakInactive,
            size: NumericConstants.iconSizeLarge,
          )
              .animate(
                onPlay: (controller) =>
                    isActive ? controller.repeat(reverse: true) : null,
              )
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.15, 1.15),
                duration: const Duration(milliseconds: 600),
              ),
          const SizedBox(width: NumericConstants.paddingSmall),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$streakCount',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: isActive
                          ? ColorConstants.streakActive
                          : ColorConstants.streakInactive,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                streakCount == 1 ? 'day' : 'days',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isActive
                          ? ColorConstants.streakActive.withOpacity(0.8)
                          : ColorConstants.streakInactive,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
