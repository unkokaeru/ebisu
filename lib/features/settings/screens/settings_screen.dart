import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ebisu/core/configuration/string_constants.dart';
import 'package:ebisu/core/configuration/numeric_constants.dart';
import 'package:ebisu/core/configuration/icon_constants.dart';
import 'package:ebisu/features/settings/providers/theme_provider.dart';
import 'package:ebisu/features/profile/providers/player_profile_provider.dart';
import 'package:ebisu/shared/services/database_service.dart';
import 'package:ebisu/shared/services/data_export_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final profileAsync = ref.watch(playerProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(NumericConstants.paddingMedium),
        children: [
          _buildSection(
            context,
            StringConstants.settingsAppearance,
            [
              _buildThemeTile(context, ref, themeMode),
            ],
          ).animate().fadeIn().slideX(begin: -0.1, end: 0),
          const SizedBox(height: NumericConstants.paddingMedium),
          _buildSection(
            context,
            StringConstants.settingsData,
            [
              _buildListTile(
                context,
                IconConstants.settingsExport,
                StringConstants.settingsExportData,
                StringConstants.settingsExportDataDescription,
                onTap: () => _showExportDialog(context),
              ),
              _buildListTile(
                context,
                IconConstants.settingsImport,
                StringConstants.settingsImportData,
                StringConstants.settingsImportDataDescription,
                onTap: () => _showImportDialog(context),
              ),
              _buildListTile(
                context,
                IconConstants.settingsReset,
                StringConstants.settingsResetData,
                StringConstants.settingsResetDataDescription,
                isDestructive: true,
                onTap: () => _showResetDialog(context, ref),
              ),
            ],
          ).animate().fadeIn(delay: const Duration(milliseconds: 100)).slideX(begin: -0.1, end: 0),
          const SizedBox(height: NumericConstants.paddingMedium),
          _buildSection(
            context,
            StringConstants.settingsAbout,
            [
              _buildListTile(
                context,
                IconConstants.settingsVersion,
                StringConstants.settingsVersion,
                '1.0.0',
              ),
              _buildListTile(
                context,
                IconConstants.settingsLicenses,
                StringConstants.settingsLicenses,
                StringConstants.settingsLicensesDescription,
                onTap: () => showLicensePage(context: context),
              ),
            ],
          ).animate().fadeIn(delay: const Duration(milliseconds: 200)).slideX(begin: -0.1, end: 0),
          const SizedBox(height: NumericConstants.paddingLarge),
          profileAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (profile) => profile != null
                ? _buildProfileCard(context, profile)
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 300))
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: NumericConstants.paddingSmall,
            bottom: NumericConstants.paddingSmall,
          ),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeTile(BuildContext context, WidgetRef ref, ThemeMode themeMode) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        themeMode == ThemeMode.dark
            ? IconConstants.settingsDarkMode
            : themeMode == ThemeMode.light
                ? IconConstants.settingsLightMode
                : IconConstants.settingsSystemTheme,
        color: theme.colorScheme.primary,
      ),
      title: const Text(StringConstants.settingsTheme),
      subtitle: Text(_getThemeModeLabel(themeMode)),
      trailing: SegmentedButton<ThemeMode>(
        segments: const [
          ButtonSegment(
            value: ThemeMode.system,
            icon: Icon(IconConstants.settingsSystemTheme),
          ),
          ButtonSegment(
            value: ThemeMode.light,
            icon: Icon(IconConstants.settingsLightMode),
          ),
          ButtonSegment(
            value: ThemeMode.dark,
            icon: Icon(IconConstants.settingsDarkMode),
          ),
        ],
        selected: {themeMode},
        onSelectionChanged: (selection) {
          ref.read(themeModeProvider.notifier).setThemeMode(selection.first);
        },
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? theme.colorScheme.error : theme.colorScheme.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? theme.colorScheme.error : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: onTap != null
          ? Icon(
              Icons.chevron_right,
              color: theme.colorScheme.outline,
            )
          : null,
      onTap: onTap,
    );
  }

  Widget _buildProfileCard(BuildContext context, dynamic profile) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.primaryContainer.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(NumericConstants.paddingMedium),
        child: Column(
          children: [
            Icon(
              IconConstants.profileAvatar,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: NumericConstants.paddingSmall),
            Text(
              profile.playerName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${StringConstants.settingsPlayingSince} ${_formatDate(profile.createdAt)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: NumericConstants.paddingMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(context, '${profile.totalExperiencePoints}', StringConstants.profileExperiencePoints),
                _buildStatItem(context, '${profile.totalTasksCompleted}', StringConstants.settingsTasks),
                _buildStatItem(context, '${profile.currentStreak}', StringConstants.settingsStreak),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  String _getThemeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return StringConstants.settingsThemeSystem;
      case ThemeMode.light:
        return StringConstants.settingsThemeLight;
      case ThemeMode.dark:
        return StringConstants.settingsThemeDark;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(StringConstants.settingsExportData),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(StringConstants.settingsExportDataConfirmation),
            const SizedBox(height: NumericConstants.paddingMedium),
            Text(
              'This will export:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: NumericConstants.paddingSmall),
            const Text('• Player profile & stats'),
            const Text('• All todos & categories'),
            const Text('• All routines & completions'),
            const Text('• All organization skills & history'),
            const Text('• All skills & achievements'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(StringConstants.actionCancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              // Show loading indicator
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: NumericConstants.paddingMedium),
                        Text('Preparing export...'),
                      ],
                    ),
                    duration: Duration(seconds: 30),
                  ),
                );
              }
              
              final result = await DataExportService.exportData();
              
              if (context.mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result.success 
                        ? '${StringConstants.settingsExportSuccess}${result.filePath != null ? '\n${result.filePath}' : ''}'
                        : result.message),
                    duration: Duration(seconds: result.success ? 3 : 5),
                    backgroundColor: result.success ? null : Theme.of(context).colorScheme.error,
                  ),
                );
              }
            },
            child: const Text(StringConstants.settingsExport),
          ),
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(StringConstants.settingsImportData),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(StringConstants.settingsImportDataConfirmation),
            const SizedBox(height: NumericConstants.paddingMedium),
            Container(
              padding: const EdgeInsets.all(NumericConstants.paddingSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(NumericConstants.borderRadiusSmall),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: Theme.of(context).colorScheme.error,
                    size: NumericConstants.iconSizeSmall,
                  ),
                  const SizedBox(width: NumericConstants.paddingSmall),
                  Expanded(
                    child: Text(
                      'Warning: This will replace all existing data!',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(StringConstants.actionCancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              // Show loading indicator
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: NumericConstants.paddingMedium),
                        Text('Importing data...'),
                      ],
                    ),
                    duration: Duration(seconds: 60),
                  ),
                );
              }
              
              final result = await DataExportService.importData();
              
              if (context.mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result.success 
                        ? StringConstants.settingsImportSuccess
                        : result.message),
                    duration: Duration(seconds: result.success ? 3 : 5),
                    backgroundColor: result.success ? null : Theme.of(context).colorScheme.error,
                  ),
                );
              }
            },
            child: const Text(StringConstants.settingsImport),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(StringConstants.settingsResetData),
        content: const Text(StringConstants.settingsResetDataConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(StringConstants.actionCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              await DatabaseService.resetAllData();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(StringConstants.settingsResetSuccess)),
                );
              }
            },
            child: const Text(StringConstants.settingsReset),
          ),
        ],
      ),
    );
  }
}
