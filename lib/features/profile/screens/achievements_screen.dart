import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ebisu/core/configuration/string_constants.dart';
import 'package:ebisu/core/configuration/numeric_constants.dart';
import 'package:ebisu/features/profile/providers/player_profile_provider.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAchievementsAsync = ref.watch(allAchievementsProvider);
    final unlockedAchievementsAsync = ref.watch(unlockedAchievementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.achievementsTitle),
      ),
      body: allAchievementsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (allAchievements) {
          final unlockedIds = unlockedAchievementsAsync.valueOrNull
                  ?.map((a) => a.id)
                  .toSet() ??
              {};

          final unlockedCount = unlockedIds.length;
          final totalCount = allAchievements.length;

          return Column(
            children: [
              _buildProgressHeader(context, unlockedCount, totalCount),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(NumericConstants.paddingMedium),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: NumericConstants.paddingSmall,
                    mainAxisSpacing: NumericConstants.paddingSmall,
                  ),
                  itemCount: allAchievements.length,
                  itemBuilder: (context, index) {
                    final achievement = allAchievements[index];
                    final isUnlocked = unlockedIds.contains(achievement.id);

                    return _buildAchievementCard(
                      context,
                      achievement,
                      isUnlocked,
                      index,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressHeader(BuildContext context, int unlocked, int total) {
    final theme = Theme.of(context);
    final progress = total > 0 ? unlocked / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(NumericConstants.paddingMedium),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emoji_events,
                color: theme.colorScheme.primary,
                size: 32,
              ),
              const SizedBox(width: NumericConstants.paddingSmall),
              Text(
                '$unlocked / $total ${StringConstants.achievementsUnlocked}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: NumericConstants.paddingSmall),
          ClipRRect(
            borderRadius: BorderRadius.circular(NumericConstants.progressBarHeight / 2),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: NumericConstants.progressBarHeight,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.2, end: 0);
  }

  Widget _buildAchievementCard(
    BuildContext context,
    dynamic achievement,
    bool isUnlocked,
    int index,
  ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _showAchievementDetails(context, achievement, isUnlocked),
      child: Card(
        elevation: isUnlocked ? 2 : 0,
        color: isUnlocked
            ? theme.colorScheme.surface
            : theme.colorScheme.surface.withOpacity(0.5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
            border: isUnlocked
                ? Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    width: 2,
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(NumericConstants.paddingSmall),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.outline.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isUnlocked
                        ? Text(
                            achievement.iconEmoji,
                            style: const TextStyle(fontSize: 28),
                          )
                        : Icon(
                            Icons.lock_outline,
                            color: theme.colorScheme.outline,
                            size: 28,
                          ),
                  ),
                ),
                const SizedBox(height: NumericConstants.paddingSmall),
                Text(
                  isUnlocked ? achievement.name : '???',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isUnlocked
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 50)).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }

  void _showAchievementDetails(
    BuildContext context,
    dynamic achievement,
    bool isUnlocked,
  ) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(NumericConstants.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.outline.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isUnlocked
                    ? Text(
                        achievement.iconEmoji,
                        style: const TextStyle(fontSize: 40),
                      )
                    : Icon(
                        Icons.lock_outline,
                        color: theme.colorScheme.outline,
                        size: 40,
                      ),
              ),
            ),
            const SizedBox(height: NumericConstants.paddingMedium),
            Text(
              isUnlocked ? achievement.name : StringConstants.achievementLocked,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: NumericConstants.paddingSmall),
            Text(
              isUnlocked
                  ? achievement.description
                  : StringConstants.achievementLockedDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (isUnlocked && achievement.unlockedAt != null) ...[
              const SizedBox(height: NumericConstants.paddingMedium),
              Text(
                '${StringConstants.achievementUnlockedOn} ${_formatDate(achievement.unlockedAt!)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
            const SizedBox(height: NumericConstants.paddingLarge),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
