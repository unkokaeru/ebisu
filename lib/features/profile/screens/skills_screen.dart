import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ebisu/core/configuration/string_constants.dart';
import 'package:ebisu/core/configuration/numeric_constants.dart';
import 'package:ebisu/core/configuration/icon_constants.dart';
import 'package:ebisu/core/configuration/color_constants.dart';
import 'package:ebisu/core/utilities/experience_calculator.dart';
import 'package:ebisu/features/profile/providers/player_profile_provider.dart';
import 'package:ebisu/shared/models/skill_model.dart';

class SkillsScreen extends ConsumerStatefulWidget {
  const SkillsScreen({super.key});

  @override
  ConsumerState<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends ConsumerState<SkillsScreen> {
  @override
  Widget build(BuildContext context) {
    final skillsAsync = ref.watch(allSkillsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.skillsTitle),
      ),
      body: skillsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (skills) {
          if (skills.isEmpty) {
            return _buildEmptyState(context);
          }

          final totalSkillExperience =
              skills.fold<int>(0, (sum, skill) => sum + skill.experiencePoints);

          return Column(
            children: [
              _buildHeader(context, skills.length, totalSkillExperience),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(NumericConstants.paddingMedium),
                  itemCount: skills.length,
                  itemBuilder: (context, index) {
                    final skill = skills[index];
                    return _buildSkillCard(context, skill, index);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(NumericConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              IconConstants.profileSkillsIcon,
              size: 80,
              color: theme.colorScheme.outline.withOpacity(0.5),
            ),
            const SizedBox(height: NumericConstants.paddingMedium),
            Text(
              StringConstants.skillsEmptyTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: NumericConstants.paddingSmall),
            Text(
              StringConstants.skillsEmptyDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().fadeIn();
  }

  Widget _buildHeader(BuildContext context, int skillCount, int totalExperience) {
    final theme = Theme.of(context);

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildHeaderStat(
            context,
            IconConstants.profileSkillsIcon,
            '$skillCount',
            StringConstants.skillsTotal,
          ),
          _buildHeaderStat(
            context,
            IconConstants.experienceIcon,
            '$totalExperience',
            StringConstants.skillsTotalExperience,
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.2, end: 0);
  }

  Widget _buildHeaderStat(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildSkillCard(BuildContext context, Skill skill, int index) {
    final theme = Theme.of(context);
    final level = ExperienceCalculator.calculateLevel(skill.experiencePoints);
    final experienceInLevel =
        ExperienceCalculator.experienceProgressInCurrentLevel(skill.experiencePoints);
    final experienceForLevel = ExperienceCalculator.experienceRequiredForLevel(level + 1) -
        ExperienceCalculator.experienceRequiredForLevel(level);
    final double progress = experienceForLevel > 0 ? experienceInLevel.toDouble() / experienceForLevel.toDouble() : 1.0;
    final experienceToNext =
        ExperienceCalculator.experienceForNextLevel(skill.experiencePoints);
    final safeIdx = NumericConstants.safeAbilityIndex(skill.abilityIndex);

    return Card(
      margin: const EdgeInsets.only(bottom: NumericConstants.paddingSmall),
      child: InkWell(
        onTap: () => _showSkillDetails(context, skill, level, progress, experienceToNext),
        onLongPress: () => _showEditSkillDialog(skill),
        borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(NumericConstants.paddingMedium),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
                    ),
                    child: Center(
                      child: Icon(
                        IconData(skill.iconCodePoint, fontFamily: 'MaterialIcons'),
                        color: theme.colorScheme.onPrimaryContainer,
                        size: 28,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: ColorConstants.abilityColors[safeIdx],
                        borderRadius: BorderRadius.circular(NumericConstants.borderRadiusSmall),
                      ),
                      child: Icon(
                        IconConstants.abilityIcons[safeIdx],
                        size: NumericConstants.iconSizeTiny,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: NumericConstants.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          skill.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: NumericConstants.paddingSmall,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius:
                                BorderRadius.circular(NumericConstants.borderRadiusSmall),
                          ),
                          child: Text(
                            '${StringConstants.homeLevel} $level',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      skill.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: NumericConstants.paddingSmall),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: progress.clamp(0.0, 1.0),
                              minHeight: 6,
                              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                            ),
                          ),
                        ),
                        const SizedBox(width: NumericConstants.paddingSmall),
                        Text(
                          '${skill.experiencePoints} ${StringConstants.profileExperiencePoints}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 100)).slideX(begin: 0.1, end: 0);
  }

  void _showSkillDetails(
    BuildContext context,
    Skill skill,
    int level,
    double progress,
    int experienceToNext,
  ) {
    final theme = Theme.of(context);
    final safeIdx = NumericConstants.safeAbilityIndex(skill.abilityIndex);

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(NumericConstants.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
                  ),
                  child: Center(
                    child: Icon(
                      IconData(skill.iconCodePoint, fontFamily: 'MaterialIcons'),
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 40,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: ColorConstants.abilityColors[safeIdx],
                      borderRadius: BorderRadius.circular(NumericConstants.borderRadiusSmall),
                    ),
                    child: Icon(
                      IconConstants.abilityIcons[safeIdx],
                      size: NumericConstants.iconSizeSmall,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: NumericConstants.paddingMedium),
            Text(
              skill.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${StringConstants.homeLevel} $level',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: NumericConstants.paddingSmall),
            Text(
              skill.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: NumericConstants.paddingMedium),
            Card(
              color: theme.colorScheme.primaryContainer.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(NumericConstants.paddingMedium),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          StringConstants.skillsProgress,
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: NumericConstants.paddingSmall),
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(NumericConstants.progressBarHeight / 2),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        minHeight: NumericConstants.progressBarHeight,
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                      ),
                    ),
                    const SizedBox(height: NumericConstants.paddingSmall),
                    Text(
                      '$experienceToNext ${StringConstants.profileToNextLevel}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: NumericConstants.paddingMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  IconConstants.abilityIcons[NumericConstants.safeAbilityIndex(skill.abilityIndex)],
                  color: ColorConstants.abilityColors[NumericConstants.safeAbilityIndex(skill.abilityIndex)],
                  size: NumericConstants.iconSizeSmall,
                ),
                const SizedBox(width: NumericConstants.paddingSmall),
                Text(
                  StringConstants.abilityNames[NumericConstants.safeAbilityIndex(skill.abilityIndex)],
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: ColorConstants.abilityColors[NumericConstants.safeAbilityIndex(skill.abilityIndex)],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: NumericConstants.paddingLarge),
          ],
        ),
      ),
    );
  }

  void _showEditSkillDialog(Skill skill) {
    int selectedAbilityIndex = NumericConstants.safeAbilityIndex(skill.abilityIndex);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text(StringConstants.skillsEditSkill),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(skill.colorValue),
                        borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
                      ),
                      child: Center(
                        child: Icon(
                          IconData(skill.iconCodePoint, fontFamily: 'MaterialIcons'),
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: NumericConstants.paddingMedium),
                    Expanded(
                      child: Text(
                        skill.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: NumericConstants.paddingLarge),
                const Text(StringConstants.skillsEditAbility),
                const SizedBox(height: NumericConstants.paddingSmall),
                Wrap(
                  spacing: NumericConstants.paddingTiny,
                  runSpacing: NumericConstants.paddingTiny,
                  children: List.generate(
                    NumericConstants.abilityCount,
                    (index) => ChoiceChip(
                      label: Text(StringConstants.abilityNames[index]),
                      selected: selectedAbilityIndex == index,
                      selectedColor: ColorConstants.abilityColors[index],
                      onSelected: (selected) {
                        if (selected) {
                          setDialogState(() => selectedAbilityIndex = index);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => _confirmDeleteSkill(skill),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text(StringConstants.delete),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(StringConstants.cancel),
            ),
            TextButton(
              onPressed: () async {
                skill.abilityIndex = selectedAbilityIndex;
                await PlayerProfileController.updateSkill(skill);
                if (mounted) Navigator.pop(context);
              },
              child: const Text(StringConstants.save),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteSkill(Skill skill) {
    Navigator.pop(context); // Close edit dialog first
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(StringConstants.skillsDeleteSkill),
        content: Text('${StringConstants.skillsDeleteConfirm} "${skill.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(StringConstants.cancel),
          ),
          TextButton(
            onPressed: () async {
              await PlayerProfileController.deleteSkill(skill.id);
              if (mounted) Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text(StringConstants.delete),
          ),
        ],
      ),
    );
  }
}
