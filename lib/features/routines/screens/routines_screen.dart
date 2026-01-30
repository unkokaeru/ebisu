import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:ebisu/core/configuration/string_constants.dart';
import 'package:ebisu/core/configuration/numeric_constants.dart';
import 'package:ebisu/core/configuration/icon_constants.dart';
import 'package:ebisu/core/configuration/color_constants.dart';
import 'package:ebisu/core/configuration/route_constants.dart';
import 'package:ebisu/features/routines/providers/routine_provider.dart';
import 'package:ebisu/shared/models/routine_item_model.dart';
import 'package:ebisu/shared/widgets/animated_checkbox.dart';
import 'package:ebisu/shared/widgets/empty_state_widget.dart';

class RoutinesScreen extends ConsumerWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRoutineType = ref.watch(currentRoutineTypeProvider);
    final isMorning = currentRoutineType == RoutineType.morning;

    final morningItems = ref.watch(morningRoutineItemsProvider).valueOrNull ?? [];
    final eveningItems = ref.watch(eveningRoutineItemsProvider).valueOrNull ?? [];
    final items = isMorning ? morningItems : eveningItems;

    final todayCompletion = isMorning
        ? ref.watch(todayMorningCompletionProvider).valueOrNull
        : ref.watch(todayEveningCompletionProvider).valueOrNull;

    final completedItemIds = todayCompletion?.completedItemIds ?? [];
    final completedCount = completedItemIds.length;
    final totalCount = items.length;
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(isMorning
            ? StringConstants.routinesMorning
            : StringConstants.routinesEvening),
        actions: [
          IconButton(
            icon: Icon(
              isMorning ? IconConstants.routineEvening : IconConstants.routineMorning,
            ),
            onPressed: () {
              ref.read(currentRoutineTypeProvider.notifier).state =
                  isMorning ? RoutineType.evening : RoutineType.morning;
            },
            tooltip: StringConstants.tooltipSwitchRoutine,
          ),
          IconButton(
            icon: const Icon(IconConstants.actionEdit),
            onPressed: () {
              final type = isMorning ? 'morning' : 'evening';
              context.push('${RouteConstants.pathRoutines}/$type/edit');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildProgressHeader(context, progress, completedCount, totalCount, isMorning),
          Expanded(
            child: items.isEmpty
                ? EmptyStateWidget(
                    icon: isMorning ? IconConstants.routineMorning : IconConstants.routineEvening,
                    title: StringConstants.routinesNoItems,
                    subtitle: StringConstants.routinesAddFirstItem,
                    action: ElevatedButton.icon(
                      onPressed: () {
                        final type = isMorning ? 'morning' : 'evening';
                        context.push('${RouteConstants.pathRoutines}/$type/edit');
                      },
                      icon: const Icon(IconConstants.actionAdd),
                      label: const Text(StringConstants.routinesAddItem),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(NumericConstants.paddingMedium),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isCompleted = completedItemIds.contains(item.id);

                      return _RoutineItemTile(
                        item: item,
                        isCompleted: isCompleted,
                        isMorning: isMorning,
                        onToggle: (value) {
                          RoutineController.toggleRoutineItemCompletion(
                            routineType: currentRoutineType,
                            itemId: item.id,
                            isCompleted: value,
                          );
                        },
                      )
                          .animate()
                          .fadeIn(delay: Duration(milliseconds: index * 50))
                          .slideX(begin: -0.1, end: 0);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader(
    BuildContext context,
    double progress,
    int completed,
    int total,
    bool isMorning,
  ) {
    final color = isMorning ? ColorConstants.routineMorning : ColorConstants.routineEvening;
    final isComplete = total > 0 && completed == total;

    return Container(
      margin: const EdgeInsets.all(NumericConstants.paddingMedium),
      padding: const EdgeInsets.all(NumericConstants.paddingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isMorning ? IconConstants.routineMorning : IconConstants.routineEvening,
                    color: color,
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(
                        begin: const Offset(1.0, 1.0),
                        end: const Offset(1.1, 1.1),
                        duration: const Duration(seconds: 2),
                        curve: Curves.easeInOut,
                      ),
                  const SizedBox(width: NumericConstants.paddingSmall),
                  Text(
                    StringConstants.routinesProgress,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              if (isComplete)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: NumericConstants.paddingSmall,
                    vertical: NumericConstants.paddingTiny,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(NumericConstants.borderRadiusSmall),
                  ),
                  child: Text(
                    StringConstants.routinesCompleted,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                )
                    .animate(onPlay: (controller) => controller.repeat(reverse: true))
                    .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.05, 1.05)),
            ],
          ),
          const SizedBox(height: NumericConstants.paddingSmall),
          ClipRRect(
            borderRadius: BorderRadius.circular(NumericConstants.progressBarHeight / 2),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: NumericConstants.progressBarHeightLarge,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(height: NumericConstants.paddingSmall),
          Text(
            '$completed / $total',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.1, end: 0);
  }
}

class _RoutineItemTile extends StatelessWidget {
  final RoutineItem item;
  final bool isCompleted;
  final bool isMorning;
  final ValueChanged<bool> onToggle;

  const _RoutineItemTile({
    required this.item,
    required this.isCompleted,
    required this.isMorning,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final color = isMorning ? ColorConstants.routineMorning : ColorConstants.routineEvening;
    final safeAbilityIdx = NumericConstants.safeAbilityIndex(item.abilityIndex);
    final abilityColor = ColorConstants.abilityColors[safeAbilityIdx];

    return Card(
      child: ListTile(
        leading: AnimatedCheckbox(
          value: isCompleted,
          activeColor: color,
          onChanged: onToggle,
        ),
        title: Text(
          item.name,
          style: TextStyle(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted
                ? Theme.of(context).colorScheme.onSurface.withOpacity(0.5)
                : null,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(
              IconConstants.abilityIcons[safeAbilityIdx],
              size: NumericConstants.iconSizeTiny,
              color: abilityColor,
            ),
            const SizedBox(width: NumericConstants.paddingTiny),
            Text(
              StringConstants.abilityNames[safeAbilityIdx],
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: abilityColor,
                    fontSize: 10,
                  ),
            ),
          ],
        ),
        trailing: isCompleted
            ? Icon(
                Icons.check_circle_rounded,
                color: color,
              ).animate().scale(
                  begin: const Offset(0, 0),
                  end: const Offset(1, 1),
                  curve: Curves.elasticOut,
                )
            : null,
      ),
    );
  }
}
