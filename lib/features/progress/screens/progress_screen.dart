import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:ebisu/core/configuration/string_constants.dart';
import 'package:ebisu/core/configuration/numeric_constants.dart';
import 'package:ebisu/core/configuration/icon_constants.dart';
import 'package:ebisu/core/configuration/route_constants.dart';
import 'package:ebisu/features/progress/providers/organization_provider.dart';
import 'package:ebisu/shared/widgets/empty_state_widget.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(organizationCategoriesProvider).valueOrNull ?? [];
    final todayLogs = ref.watch(todayOrganizationLogsProvider).valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.organizationTitle),
      ),
      body: categories.isEmpty
          ? EmptyStateWidget(
              icon: IconConstants.organizationCategory,
              title: StringConstants.organizationNoCategories,
              subtitle: StringConstants.organizationAddFirstCategory,
              action: ElevatedButton.icon(
                onPressed: () => context.push('${RouteConstants.pathProgress}/add'),
                icon: const Icon(IconConstants.actionAdd),
                label: const Text(StringConstants.organizationAddCategory),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(NumericConstants.paddingMedium),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final log = todayLogs.where((l) => l.categoryId == category.id).firstOrNull;
                final currentLevel = log?.completedLevel ?? 0;
                final isCarriedOver = log?.isCarriedOver ?? false;

                return _OrganizationCategoryCard(
                  name: category.name,
                  iconCodePoint: category.iconCodePoint,
                  colorValue: category.colorValue,
                  currentLevel: currentLevel,
                  isCarriedOver: isCarriedOver,
                  onTap: () => context.push('${RouteConstants.pathProgress}/${category.id}'),
                )
                    .animate()
                    .fadeIn(delay: Duration(milliseconds: index * 100))
                    .slideX(begin: -0.1, end: 0);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('${RouteConstants.pathProgress}/add'),
        child: const Icon(IconConstants.actionAdd),
      )
          .animate().fadeIn().scale()
          .then()
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.05, 1.05),
            duration: const Duration(seconds: 2),
          ),
    );
  }
}

class _OrganizationCategoryCard extends StatelessWidget {
  final String name;
  final int iconCodePoint;
  final int colorValue;
  final int currentLevel;
  final bool isCarriedOver;
  final VoidCallback onTap;

  const _OrganizationCategoryCard({
    required this.name,
    required this.iconCodePoint,
    required this.colorValue,
    required this.currentLevel,
    required this.isCarriedOver,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(colorValue);
    final double progress = currentLevel.toDouble() / NumericConstants.organizationMaxLevel.toDouble();

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(NumericConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(NumericConstants.paddingSmall),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(NumericConstants.borderRadiusSmall),
                    ),
                    child: Icon(
                      IconData(iconCodePoint, fontFamily: 'MaterialIcons'),
                      color: color,
                    ),
                  ),
                  const SizedBox(width: NumericConstants.paddingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            if (isCarriedOver) ...[
                              const SizedBox(width: NumericConstants.paddingSmall),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: NumericConstants.paddingSmall,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(NumericConstants.borderRadiusSmall),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      IconConstants.organizationCarriedOver,
                                      size: 12,
                                      color: Theme.of(context).colorScheme.tertiary,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      'Carried',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Theme.of(context).colorScheme.tertiary,
                                            fontSize: 10,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          '${StringConstants.organizationCurrentLevel}: $currentLevel / ${StringConstants.organizationMaxLevel}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: NumericConstants.iconSizeSmall,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ],
              ),
              const SizedBox(height: NumericConstants.paddingSmall),
              ClipRRect(
                borderRadius: BorderRadius.circular(NumericConstants.progressBarHeight / 2),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: NumericConstants.progressBarHeight,
                  backgroundColor: color.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
              const SizedBox(height: NumericConstants.paddingSmall),
              Row(
                children: List.generate(
                  NumericConstants.organizationMaxLevel,
                  (index) => Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(
                        right: index < NumericConstants.organizationMaxLevel - 1 ? 2 : 0,
                      ),
                      decoration: BoxDecoration(
                        color: index < currentLevel ? color : color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
