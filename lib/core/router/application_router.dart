import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ebisu/core/configuration/route_constants.dart';
import 'package:ebisu/features/home/screens/home_screen.dart';
import 'package:ebisu/features/todos/screens/todos_screen.dart';
import 'package:ebisu/features/todos/screens/todo_form_screen.dart';
import 'package:ebisu/features/todos/screens/picker_wheel_screen.dart';
import 'package:ebisu/features/routines/screens/routines_screen.dart';
import 'package:ebisu/features/routines/screens/routine_edit_screen.dart';
import 'package:ebisu/features/progress/screens/progress_screen.dart';
import 'package:ebisu/features/progress/screens/organization_form_screen.dart';
import 'package:ebisu/features/progress/screens/organization_detail_screen.dart';
import 'package:ebisu/features/profile/screens/profile_screen.dart';
import 'package:ebisu/features/profile/screens/achievements_screen.dart';
import 'package:ebisu/features/profile/screens/skills_screen.dart';
import 'package:ebisu/features/settings/screens/settings_screen.dart';
import 'package:ebisu/features/onboarding/screens/onboarding_screen.dart';
import 'package:ebisu/features/onboarding/providers/onboarding_provider.dart';
import 'package:ebisu/shared/widgets/main_navigation_shell.dart';

final applicationRouterProvider = Provider<GoRouter>((ref) {
  final isOnboardingComplete = ref.watch(isOnboardingCompleteProvider);

  return GoRouter(
    initialLocation: RouteConstants.pathHome,
    redirect: (context, state) {
      final onboardingComplete = isOnboardingComplete.valueOrNull ?? false;
      final isOnboardingRoute = state.matchedLocation == RouteConstants.pathOnboarding;

      if (!onboardingComplete && !isOnboardingRoute) {
        return RouteConstants.pathOnboarding;
      }

      if (onboardingComplete && isOnboardingRoute) {
        return RouteConstants.pathHome;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteConstants.pathOnboarding,
        name: RouteConstants.nameOnboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainNavigationShell(child: child),
        routes: [
          GoRoute(
            path: RouteConstants.pathHome,
            name: RouteConstants.nameHome,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: RouteConstants.pathTodos,
            name: RouteConstants.nameTodos,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const TodosScreen(),
            ),
            routes: [
              GoRoute(
                path: 'add',
                name: RouteConstants.nameTodoAdd,
                builder: (context, state) => const TodoFormScreen(),
              ),
              GoRoute(
                path: 'edit/:id',
                name: RouteConstants.nameTodoEdit,
                builder: (context, state) {
                  final todoId = int.parse(state.pathParameters['id']!);
                  return TodoFormScreen(todoId: todoId);
                },
              ),
              GoRoute(
                path: 'wheel',
                name: RouteConstants.namePickerWheel,
                builder: (context, state) => const PickerWheelScreen(),
              ),
            ],
          ),
          GoRoute(
            path: RouteConstants.pathRoutines,
            name: RouteConstants.nameRoutines,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const RoutinesScreen(),
            ),
            routes: [
              GoRoute(
                path: ':type/edit',
                name: RouteConstants.nameRoutineEdit,
                builder: (context, state) {
                  final type = state.pathParameters['type']!;
                  return RoutineEditScreen(routineType: type);
                },
              ),
            ],
          ),
          GoRoute(
            path: RouteConstants.pathProgress,
            name: RouteConstants.nameProgress,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProgressScreen(),
            ),
            routes: [
              GoRoute(
                path: 'add',
                name: RouteConstants.nameOrganizationAdd,
                builder: (context, state) => const OrganizationFormScreen(),
              ),
              GoRoute(
                path: 'edit/:id',
                name: RouteConstants.nameOrganizationEdit,
                builder: (context, state) {
                  final categoryId = int.parse(state.pathParameters['id']!);
                  return OrganizationFormScreen(categoryId: categoryId);
                },
              ),
              GoRoute(
                path: ':id',
                name: RouteConstants.nameOrganizationDetail,
                builder: (context, state) {
                  final categoryId = int.parse(state.pathParameters['id']!);
                  return OrganizationDetailScreen(categoryId: categoryId);
                },
              ),
            ],
          ),
          GoRoute(
            path: RouteConstants.pathProfile,
            name: RouteConstants.nameProfile,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProfileScreen(),
            ),
            routes: [
              GoRoute(
                path: 'achievements',
                name: RouteConstants.nameAchievements,
                builder: (context, state) => const AchievementsScreen(),
              ),
              GoRoute(
                path: 'skills',
                name: RouteConstants.nameSkills,
                builder: (context, state) => const SkillsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RouteConstants.pathSettings,
        name: RouteConstants.nameSettings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
