import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ebisu/core/configuration/numeric_constants.dart';
import 'package:ebisu/core/configuration/string_constants.dart';

class ExperienceGainNotification extends StatelessWidget {
  final int experienceGained;
  final VoidCallback? onDismiss;

  const ExperienceGainNotification({
    super.key,
    required this.experienceGained,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: NumericConstants.paddingMedium,
        vertical: NumericConstants.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
        borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: Colors.white,
            size: NumericConstants.iconSizeMedium,
          ),
          const SizedBox(width: NumericConstants.paddingSmall),
          Text(
            '+$experienceGained ${StringConstants.homeExperiencePoints}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 200))
        .slideY(begin: -0.5, end: 0)
        .then(delay: const Duration(seconds: 2))
        .fadeOut()
        .callback(callback: (_) => onDismiss?.call());
  }
}

class LevelUpNotification extends StatelessWidget {
  final int newLevel;
  final String? newRank;
  final VoidCallback? onDismiss;

  const LevelUpNotification({
    super.key,
    required this.newLevel,
    this.newRank,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(NumericConstants.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(NumericConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.military_tech_rounded,
            color: Colors.white,
            size: NumericConstants.iconSizeHuge,
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.2, 1.2),
                duration: const Duration(milliseconds: 500),
              ),
          const SizedBox(height: NumericConstants.paddingMedium),
          Text(
            StringConstants.leveledUp,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: NumericConstants.paddingSmall),
          Text(
            '${StringConstants.homeLevel} $newLevel',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
          ),
          if (newRank != null) ...[
            const SizedBox(height: NumericConstants.paddingSmall),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: NumericConstants.paddingMedium,
                vertical: NumericConstants.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
              ),
              child: Text(
                newRank!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        ],
      ),
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 300))
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0))
        .then(delay: const Duration(seconds: 3))
        .fadeOut()
        .callback(callback: (_) => onDismiss?.call());
  }
}
