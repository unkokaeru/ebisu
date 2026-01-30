import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:ebisu/core/configuration/string_constants.dart';
import 'package:ebisu/core/configuration/numeric_constants.dart';
import 'package:ebisu/core/configuration/icon_constants.dart';
import 'package:ebisu/core/configuration/route_constants.dart';
import 'package:ebisu/core/utilities/date_time_utilities.dart';
import 'package:ebisu/core/utilities/experience_calculator.dart';
import 'package:ebisu/features/profile/providers/player_profile_provider.dart';
import 'package:ebisu/features/todos/providers/todo_provider.dart';
import 'package:ebisu/features/routines/providers/routine_provider.dart';
import 'package:ebisu/shared/models/routine_item_model.dart';
import 'package:ebisu/shared/widgets/experience_progress_bar.dart';
import 'package:ebisu/shared/widgets/streak_indicator.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(playerProfileProvider).valueOrNull;
    final level = ref.watch(playerLevelProvider);
    final rank = ref.watch(playerRankProvider);
    final urgentTodos = ref.watch(urgentImportantTodosProvider);
    final currentRoutineType = ref.watch(currentRoutineTypeProvider);

    if (profile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final greeting = DateTimeUtilities.getGreeting();
    final progressPercentage = ExperienceCalculator.levelProgressPercentage(
      profile.totalExperiencePoints,
    );
    final currentLevelXp = profile.totalExperiencePoints -
        ExperienceCalculator.experiencePointsForLevel(level);
    final nextLevelXp = ExperienceCalculator.experiencePointsForLevel(level + 1) -
        ExperienceCalculator.experiencePointsForLevel(level);

    return Scaffold(
      appBar: AppBar(
        title: Text(StringConstants.applicationName),
        actions: [
          IconButton(
            icon: const Icon(IconConstants.actionSettings),
            onPressed: () => context.push(RouteConstants.pathSettings),
            tooltip: StringConstants.settingsTitle,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(NumericConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreetingCard(context, greeting, profile.playerName, level, rank, progressPercentage, currentLevelXp, nextLevelXp)
                .animate()
                .fadeIn()
                .slideX(begin: -0.1, end: 0),
            const SizedBox(height: NumericConstants.paddingMedium),
            _buildStreakCard(context, profile.currentStreak)
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 100))
                .slideX(begin: 0.1, end: 0),
            const SizedBox(height: NumericConstants.paddingMedium),
            _buildTodaysFocusCard(context, urgentTodos)
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 200))
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: NumericConstants.paddingMedium),
            _buildQuickRoutineCard(context, ref, currentRoutineType)
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 300))
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: NumericConstants.paddingMedium),
            _buildQuickActionsCard(context)
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 400))
                .slideY(begin: 0.1, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildGreetingCard(
    BuildContext context,
    String greeting,
    String playerName,
    int level,
    String rank,
    double progressPercentage,
    int currentLevelXp,
    int nextLevelXp,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(NumericConstants.paddingMedium),
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
                        '$greeting,',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                      ),
                      Text(
                        playerName,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: NumericConstants.paddingMedium,
                    vertical: NumericConstants.paddingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${StringConstants.homeLevel} $level',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        rank,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: NumericConstants.paddingMedium),
            ExperienceProgressBar(
              progress: progressPercentage,
              currentExperience: currentLevelXp,
              targetExperience: nextLevelXp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context, int streak) {
    final isActive = streak > 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(NumericConstants.paddingMedium),
        child: Row(
          children: [
            // Add pulse animation when streak is active
            if (isActive)
              StreakIndicator(streakCount: streak)
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.08, 1.08),
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.easeInOut,
                  )
            else
              StreakIndicator(streakCount: streak),
            const Spacer(),
            Text(
              StringConstants.homeCurrentStreak,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysFocusCard(BuildContext context, List urgentTodos) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(NumericConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  IconConstants.quadrantUrgentImportant,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: NumericConstants.paddingSmall),
                Text(
                  StringConstants.homeTodaysFocus,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: NumericConstants.paddingSmall),
            if (urgentTodos.isEmpty)
              Text(
                StringConstants.homeNoFocusTasks,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
              )
            else
              ...urgentTodos.take(3).map(
                    (todo) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: NumericConstants.paddingTiny),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(width: NumericConstants.paddingSmall),
                          Expanded(
                            child: Text(
                              todo.title,
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
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

  Widget _buildQuickRoutineCard(BuildContext context, WidgetRef ref, RoutineType currentRoutineType) {
    final isMorning = currentRoutineType == RoutineType.morning;

    return Card(
      child: InkWell(
        onTap: () => context.go(RouteConstants.pathRoutines),
        borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(NumericConstants.paddingMedium),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(NumericConstants.paddingSmall),
                decoration: BoxDecoration(
                  color: (isMorning
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.secondary)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(NumericConstants.borderRadiusSmall),
                ),
                child: Icon(
                  isMorning ? IconConstants.routineMorning : IconConstants.routineEvening,
                  color: isMorning
                      ? Theme.of(context).colorScheme.tertiary
                      : Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(width: NumericConstants.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isMorning
                          ? StringConstants.routinesMorning
                          : StringConstants.routinesEvening,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      StringConstants.routinesProgress,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: NumericConstants.iconSizeSmall,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(NumericConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringConstants.homeQuickActions,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: NumericConstants.paddingSmall),
            Row(
              children: [
                Expanded(
                  child: _QuickActionButton(
                    icon: IconConstants.actionAdd,
                    label: StringConstants.todosAddTask,
                    onTap: () => context.push('${RouteConstants.pathTodos}/add'),
                  ),
                ),
                const SizedBox(width: NumericConstants.paddingSmall),
                Expanded(
                  child: _QuickActionButton(
                    icon: IconConstants.actionSpin,
                    label: StringConstants.todosSpinWheel,
                    onTap: () => context.push('${RouteConstants.pathTodos}/wheel'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
        child: Container(
          padding: const EdgeInsets.all(NumericConstants.paddingMedium),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
          ),
          child: Column(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: NumericConstants.paddingSmall),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
