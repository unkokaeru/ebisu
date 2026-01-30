import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:ebisu/core/configuration/string_constants.dart';
import 'package:ebisu/core/configuration/numeric_constants.dart';
import 'package:ebisu/core/configuration/icon_constants.dart';
import 'package:ebisu/core/configuration/route_constants.dart';
import 'package:ebisu/core/utilities/date_time_utilities.dart';
import 'package:ebisu/features/progress/providers/organization_provider.dart';
import 'package:ebisu/shared/widgets/animated_checkbox.dart';

class OrganizationDetailScreen extends ConsumerWidget {
  final int categoryId;

  const OrganizationDetailScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAsync = ref.watch(organizationCategoryProvider(categoryId));
    final log = ref.watch(organizationLogForCategoryProvider(categoryId));
    final historyAsync = ref.watch(organizationHistoryProvider(categoryId));

    return categoryAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
      data: (category) {
        if (category == null) {
          return const Scaffold(
            body: Center(child: Text('Category not found')),
          );
        }

        final color = Color(category.colorValue);
        final currentLevel = log?.completedLevel ?? 0;
        final history = historyAsync.valueOrNull ?? [];

        return Scaffold(
          appBar: AppBar(
            title: Text(category.name),
            actions: [
              IconButton(
                icon: const Icon(IconConstants.actionEdit),
                onPressed: () =>
                    context.push('${RouteConstants.pathProgress}/edit/$categoryId'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(NumericConstants.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, category.name, category.iconCodePoint, color, currentLevel),
                const SizedBox(height: NumericConstants.paddingMedium),
                Text(
                  StringConstants.organizationTodayProgress,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: NumericConstants.paddingSmall),
                _buildLevelChecklist(context, ref, category.levels, currentLevel, color),
                const SizedBox(height: NumericConstants.paddingLarge),
                Text(
                  StringConstants.organizationHistory,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: NumericConstants.paddingSmall),
                _buildHistoryChart(context, history, color),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    String name,
    int iconCodePoint,
    Color color,
    int currentLevel,
  ) {
    final double progress = currentLevel.toDouble() / NumericConstants.organizationMaxLevel.toDouble();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(NumericConstants.paddingMedium),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(NumericConstants.paddingMedium),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
                  ),
                  child: Icon(
                    IconData(iconCodePoint, fontFamily: 'MaterialIcons'),
                    color: color,
                    size: NumericConstants.iconSizeLarge,
                  ),
                ),
                const SizedBox(width: NumericConstants.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '${StringConstants.homeLevel} $currentLevel / ${NumericConstants.organizationMaxLevel}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: color,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: NumericConstants.paddingMedium),
            ClipRRect(
              borderRadius: BorderRadius.circular(NumericConstants.progressBarHeightLarge / 2),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: NumericConstants.progressBarHeightLarge,
                backgroundColor: color.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: -0.1, end: 0);
  }

  Widget _buildLevelChecklist(
    BuildContext context,
    WidgetRef ref,
    List<String> levels,
    int currentLevel,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(NumericConstants.paddingSmall),
        child: Column(
          children: List.generate(
            levels.length,
            (index) {
              final levelNumber = index + 1;
              final isCompleted = levelNumber <= currentLevel;
              final isNext = levelNumber == currentLevel + 1;

              return InkWell(
                onTap: () async {
                  if (isCompleted) {
                    await OrganizationController.logOrganizationLevel(
                      categoryId: categoryId,
                      completedLevel: levelNumber - 1,
                    );
                  } else {
                    await OrganizationController.logOrganizationLevel(
                      categoryId: categoryId,
                      completedLevel: levelNumber,
                    );
                  }
                },
                borderRadius: BorderRadius.circular(NumericConstants.borderRadiusSmall),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: NumericConstants.paddingSmall,
                    vertical: NumericConstants.paddingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: isNext ? color.withOpacity(0.05) : null,
                    borderRadius: BorderRadius.circular(NumericConstants.borderRadiusSmall),
                  ),
                  child: Row(
                    children: [
                      AnimatedCheckbox(
                        value: isCompleted,
                        activeColor: color,
                        onChanged: (value) async {
                          if (value) {
                            await OrganizationController.logOrganizationLevel(
                              categoryId: categoryId,
                              completedLevel: levelNumber,
                            );
                          } else {
                            await OrganizationController.logOrganizationLevel(
                              categoryId: categoryId,
                              completedLevel: levelNumber - 1,
                            );
                          }
                        },
                      ),
                      const SizedBox(width: NumericConstants.paddingSmall),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isCompleted ? color : color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$levelNumber',
                            style: TextStyle(
                              color: isCompleted ? Colors.white : color,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: NumericConstants.paddingSmall),
                      Expanded(
                        child: Text(
                          levels[index],
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                decoration: isCompleted ? TextDecoration.lineThrough : null,
                                color: isCompleted
                                    ? Theme.of(context).colorScheme.onSurface.withOpacity(0.5)
                                    : null,
                              ),
                        ),
                      ),
                      if (isNext)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: NumericConstants.paddingSmall,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(NumericConstants.borderRadiusSmall),
                          ),
                          child: Text(
                            'Next',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: Duration(milliseconds: index * 50));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryChart(BuildContext context, List history, Color color) {
    final lastDays = DateTimeUtilities.getLastNDays(NumericConstants.chartHistoryDays);

    final spots = lastDays.asMap().entries.map((entry) {
      final index = entry.key;
      final date = entry.value;

      final log = history.where((l) => DateTimeUtilities.isSameDay(l.date, date)).firstOrNull;
      final double level = log?.completedLevel.toDouble() ?? 0.0;

      return FlSpot(index.toDouble(), level);
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(NumericConstants.paddingMedium),
        child: SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: NumericConstants.organizationMaxLevel.toDouble(),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 2,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 2,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= lastDays.length) return const SizedBox();
                      final date = lastDays[index];
                      return Text(
                        '${date.day}',
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: color,
                  barWidth: NumericConstants.chartLineWidth,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                      radius: 4,
                      color: color,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: color.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 300));
  }
}
