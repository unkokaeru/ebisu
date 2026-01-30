import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebisu/core/theme/application_theme.dart';
import 'package:ebisu/core/router/application_router.dart';
import 'package:ebisu/core/configuration/string_constants.dart';
import 'package:ebisu/features/settings/providers/theme_provider.dart';

class EbisuApplication extends ConsumerWidget {
  const EbisuApplication({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(applicationRouterProvider);

    return MaterialApp.router(
      title: StringConstants.applicationName,
      debugShowCheckedModeBanner: false,
      theme: ApplicationTheme.lightTheme,
      darkTheme: ApplicationTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
