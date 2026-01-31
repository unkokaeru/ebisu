import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:ebisu/core/configuration/string_constants.dart';
import 'package:ebisu/core/configuration/numeric_constants.dart';
import 'package:ebisu/core/configuration/icon_constants.dart';
import 'package:ebisu/core/configuration/color_constants.dart';
import 'package:ebisu/core/configuration/route_constants.dart';
import 'package:ebisu/core/utilities/experience_calculator.dart';
import 'package:ebisu/features/profile/providers/player_profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(playerProfileProvider);
    final skillsAsync = ref.watch(allSkillsProvider);
    final unlockedAchievementsAsync = ref.watch(unlockedAchievementsProvider);
    final abilityScores = ref.watch(actualAbilityScoresProvider);
    final skillsByAbility = ref.watch(actualSkillsByAbilityProvider);
    final activityByAbility = ref.watch(activityCountByAbilityProvider);

    return Scaffold(
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No profile found'));
          }

          final currentLevel = ExperienceCalculator.calculateLevel(profile.totalExperiencePoints);
          final rank = ExperienceCalculator.getRankForLevel(currentLevel);
          final experienceForNextLevel =
              ExperienceCalculator.experienceForNextLevel(profile.totalExperiencePoints);
          final experienceProgress =
              ExperienceCalculator.experienceProgressInCurrentLevel(profile.totalExperiencePoints);
          final totalForLevel = ExperienceCalculator.experienceRequiredForLevel(currentLevel + 1) -
              ExperienceCalculator.experienceRequiredForLevel(currentLevel);
          final progress = totalForLevel > 0 ? experienceProgress / totalForLevel : 1.0;

          final skills = skillsAsync.valueOrNull ?? [];
          final unlockedAchievements = unlockedAchievementsAsync.valueOrNull ?? [];

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildCharacterCard(
                    context,
                    profile.playerName,
                    currentLevel,
                    rank,
                    profile.totalExperiencePoints,
                    experienceForNextLevel,
                    progress,
                    profile.currentStreak,
                    profile.longestStreak,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(NumericConstants.paddingMedium),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildStatsRow(context, profile),
                    const SizedBox(height: NumericConstants.paddingLarge),
                    _buildAbilitiesSection(context, abilityScores, skillsByAbility, activityByAbility),
                    const SizedBox(height: NumericConstants.paddingLarge),
                    _buildSkillsPreview(context, skills),
                    const SizedBox(height: NumericConstants.paddingLarge),
                    _buildAchievementsPreview(context, unlockedAchievements),
                    const SizedBox(height: NumericConstants.paddingLarge),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCharacterCard(
    BuildContext context,
    String name,
    int level,
    String rank,
    int totalExperience,
    int experienceToNext,
    double progress,
    int currentStreak,
    int longestStreak,
  ) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
            theme.colorScheme.primaryContainer.withOpacity(0.6),
          ],
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Decorative circles in background
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NumericConstants.paddingMedium,
                vertical: NumericConstants.paddingSmall,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Avatar with level badge
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer glow
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      // Avatar ring
                      Container(
                        width: 74,
                        height: 74,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.8),
                              Colors.white.withOpacity(0.4),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(2),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.primary.withOpacity(0.3),
                          ),
                          child: const Icon(
                            IconConstants.profileAvatar,
                            size: 38,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Level badge
                      Positioned(
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber.shade600,
                                Colors.amber.shade400,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            'Lv $level',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                      .animate().scale(duration: const Duration(milliseconds: 300))
                      .then()
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .moveY(
                        begin: 0,
                        end: -4,
                        duration: const Duration(milliseconds: 2000),
                        curve: Curves.easeInOut,
                      ),
                  const SizedBox(height: NumericConstants.paddingSmall),
                  // Name
                  Text(
                    name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 100)),
                  const SizedBox(height: 2),
                  // Rank with decorative elements
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 20, height: 1, color: Colors.white38),
                      const SizedBox(width: 8),
                      Text(
                        rank,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(width: 20, height: 1, color: Colors.white38),
                    ],
                  ).animate().fadeIn(delay: const Duration(milliseconds: 150)),
                  const SizedBox(height: NumericConstants.paddingSmall),
                  // Streak chips
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatChip(context, Icons.local_fire_department, '$currentStreak day', Colors.orange),
                      const SizedBox(width: NumericConstants.paddingSmall),
                      _buildStatChip(context, Icons.emoji_events, 'Best: $longestStreak', Colors.amber),
                    ],
                  ),
                  const SizedBox(height: NumericConstants.paddingSmall),
                  // XP Progress bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: NumericConstants.paddingLarge),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.star, size: 14, color: Colors.amber.shade300),
                                const SizedBox(width: 4),
                                Text(
                                  '$totalExperience XP',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '$experienceToNext to next level',
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child: Stack(
                            children: [
                              FractionallySizedBox(
                                widthFactor: progress.clamp(0.0, 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.amber.shade300,
                                        Colors.amber.shade500,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.amber.withOpacity(0.5),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(BuildContext context, IconData icon, String text, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, dynamic profile) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(NumericConstants.paddingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surfaceContainerHighest,
            theme.colorScheme.surfaceContainerHigh,
          ],
        ),
        borderRadius: BorderRadius.circular(NumericConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              IconConstants.todosNavigationIcon,
              StringConstants.profileTotalTasksCompleted,
              '${profile.totalTasksCompleted}',
              theme.colorScheme.primary,
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: theme.dividerColor.withOpacity(0.3),
          ),
          Expanded(
            child: _buildStatCard(
              context,
              IconConstants.routinesNavigationIcon,
              StringConstants.profileRoutinesCompleted,
              '${profile.totalRoutinesCompleted}',
              theme.colorScheme.secondary,
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: theme.dividerColor.withOpacity(0.3),
          ),
          Expanded(
            child: _buildStatCard(
              context,
              Icons.emoji_events_rounded,
              StringConstants.profileLongestStreak,
              '${profile.longestStreak}',
              Colors.amber,
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildAbilitiesSection(
    BuildContext context,
    List<int> abilityScores,
    Map<int, List<dynamic>> skillsByAbility,
    Map<int, int> activityByAbility,
  ) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive: more columns on wider screens, with max card width
    const maxCardWidth = 110.0;
    const minCardWidth = 90.0;
    const spacing = 8.0;
    const horizontalPadding = 32.0;
    final availableWidth = screenWidth - horizontalPadding;
    
    // Calculate how many cards fit
    int crossAxisCount = (availableWidth / (minCardWidth + spacing)).floor();
    crossAxisCount = crossAxisCount.clamp(3, 6);
    
    final cardWidth = ((availableWidth - (crossAxisCount - 1) * spacing) / crossAxisCount)
        .clamp(minCardWidth, maxCardWidth);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.auto_awesome, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              StringConstants.abilitiesTitle,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: NumericConstants.paddingMedium),
        Center(
          child: Wrap(
            spacing: spacing,
            runSpacing: spacing,
            alignment: WrapAlignment.center,
            children: List.generate(NumericConstants.abilityCount, (index) {
              final score = abilityScores[index];
              final activityCount = activityByAbility[index] ?? 0;
              final color = ColorConstants.abilityColors[index];

              return SizedBox(
                width: cardWidth,
                child: AspectRatio(
                  aspectRatio: 0.9,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(NumericConstants.borderRadiusLarge),
                      onTap: () => _showAbilityDetails(context, index, abilityScores[index], skillsByAbility[index] ?? [], activityCount),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              color.withOpacity(0.15),
                              color.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusLarge),
                          border: Border.all(
                            color: color.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  IconConstants.abilityIcons[index],
                                  color: color,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                score.toString(),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                              Text(
                                StringConstants.abilityNames[index],
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (activityCount > 0)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    '$activityCount done',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: color,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ).animate(delay: Duration(milliseconds: index * 50)).fadeIn().scale(begin: const Offset(0.8, 0.8)),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  void _showAbilityDetails(
    BuildContext context,
    int abilityIndex,
    int score,
    List<dynamic> skills,
    int activityCount,
  ) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(NumericConstants.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  IconConstants.abilityIcons[abilityIndex],
                  color: ColorConstants.abilityColors[abilityIndex],
                  size: NumericConstants.iconSizeExtraLarge,
                ),
                const SizedBox(width: NumericConstants.paddingMedium),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringConstants.abilityNames[abilityIndex],
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      StringConstants.abilityDescriptions[abilityIndex],
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: NumericConstants.paddingMedium,
                    vertical: NumericConstants.paddingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: ColorConstants.abilityColors[abilityIndex],
                    borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
                  ),
                  child: Text(
                    score.toString(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: NumericConstants.paddingLarge),
            // Activity Statistics
            Container(
              padding: const EdgeInsets.all(NumericConstants.paddingMedium),
              decoration: BoxDecoration(
                color: ColorConstants.abilityColors[abilityIndex].withOpacity(0.1),
                borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline, size: 20),
                  const SizedBox(width: NumericConstants.paddingSmall),
                  Text(
                    '$activityCount activities completed',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: NumericConstants.paddingLarge),
            Text(
              'Contributing Skills',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: NumericConstants.paddingSmall),
            if (skills.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(NumericConstants.paddingLarge),
                  child: Text(
                    'No skills yet. Add skills under this ability to increase your score!',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ),
              )
            else
              ...skills.map((skill) {
                final level = ExperienceCalculator.calculateLevel(skill.experiencePoints);
                return ListTile(
                    leading: Icon(
                      IconData(skill.iconCodePoint, fontFamily: 'MaterialIcons'),
                      color: Color(skill.colorValue),
                    ),
                    title: Text(skill.name),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: NumericConstants.paddingSmall,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: ColorConstants.abilityColors[abilityIndex],
                        borderRadius: BorderRadius.circular(NumericConstants.borderRadiusSmall),
                      ),
                      child: Text(
                        'Lv $level',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                  );
              }),
            const SizedBox(height: NumericConstants.paddingMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color accentColor,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: NumericConstants.paddingSmall),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsPreview(BuildContext context, List skills) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  StringConstants.profileSkills,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () => context.push(RouteConstants.pathSkills),
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text(StringConstants.homeSeeAll),
            ),
          ],
        ),
        const SizedBox(height: NumericConstants.paddingSmall),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(NumericConstants.borderRadiusLarge),
            border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
          ),
          child: skills.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(NumericConstants.paddingLarge),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.psychology_outlined,
                          size: 48,
                          color: theme.colorScheme.onSurface.withOpacity(0.3),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          StringConstants.profileNoSkillsYet,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: skills.take(3).toList().asMap().entries.map<Widget>((entry) {
                    final index = entry.key;
                    final skill = entry.value;
                    final level = ExperienceCalculator.calculateLevel(skill.experiencePoints);
                    final progress = ExperienceCalculator.experienceProgressInCurrentLevel(
                            skill.experiencePoints) /
                        (ExperienceCalculator.experienceRequiredForLevel(level + 1) -
                            ExperienceCalculator.experienceRequiredForLevel(level));
                    final skillColor = Color(skill.colorValue);

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(NumericConstants.paddingMedium),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      skillColor.withOpacity(0.3),
                                      skillColor.withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: skillColor.withOpacity(0.5),
                                  ),
                                ),
                                child: Icon(
                                  IconData(skill.iconCodePoint, fontFamily: 'MaterialIcons'),
                                  color: skillColor,
                                  size: 22,
                                ),
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
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: skillColor.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            'Lv $level',
                                            style: theme.textTheme.labelSmall?.copyWith(
                                              color: skillColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Stack(
                                      children: [
                                        Container(
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: skillColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                        ),
                                        FractionallySizedBox(
                                          widthFactor: progress.clamp(0.0, 1.0),
                                          child: Container(
                                            height: 6,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  skillColor,
                                                  skillColor.withOpacity(0.7),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(3),
                                            ),
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
                        if (index < (skills.length > 3 ? 2 : skills.length - 1))
                          Divider(
                            height: 1,
                            indent: NumericConstants.paddingMedium,
                            endIndent: NumericConstants.paddingMedium,
                            color: theme.dividerColor.withOpacity(0.1),
                          ),
                      ],
                    );
                  }).toList(),
                ),
        ),
      ],
    ).animate().fadeIn(delay: const Duration(milliseconds: 200));
  }

  Widget _buildAchievementsPreview(BuildContext context, List achievements) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.military_tech, size: 20, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  StringConstants.profileAchievements,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () => context.push(RouteConstants.pathAchievements),
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text(StringConstants.homeSeeAll),
            ),
          ],
        ),
        const SizedBox(height: NumericConstants.paddingSmall),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(NumericConstants.borderRadiusLarge),
            border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
          ),
          child: achievements.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(NumericConstants.paddingLarge),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.emoji_events_outlined,
                          size: 48,
                          color: theme.colorScheme.onSurface.withOpacity(0.3),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          StringConstants.profileNoAchievementsYet,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(NumericConstants.paddingMedium),
                  child: Wrap(
                    spacing: NumericConstants.paddingSmall,
                    runSpacing: NumericConstants.paddingSmall,
                    children: achievements.take(6).map<Widget>((achievement) {
                      return Tooltip(
                        message: achievement.name,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.amber.withOpacity(0.2),
                                Colors.orange.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
                            border: Border.all(
                              color: Colors.amber.withOpacity(0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              achievement.iconEmoji,
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
        ),
      ],
    ).animate().fadeIn(delay: const Duration(milliseconds: 300));
  }
}
