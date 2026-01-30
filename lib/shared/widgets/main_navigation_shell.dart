import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ebisu/core/configuration/string_constants.dart';
import 'package:ebisu/core/configuration/icon_constants.dart';
import 'package:ebisu/core/configuration/route_constants.dart';

class MainNavigationShell extends StatelessWidget {
  final Widget child;

  const MainNavigationShell({
    super.key,
    required this.child,
  });

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    if (location.startsWith(RouteConstants.pathHome)) return 0;
    if (location.startsWith(RouteConstants.pathTodos)) return 1;
    if (location.startsWith(RouteConstants.pathRoutines)) return 2;
    if (location.startsWith(RouteConstants.pathProgress)) return 3;
    if (location.startsWith(RouteConstants.pathProfile)) return 4;

    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RouteConstants.pathHome);
        break;
      case 1:
        context.go(RouteConstants.pathTodos);
        break;
      case 2:
        context.go(RouteConstants.pathRoutines);
        break;
      case 3:
        context.go(RouteConstants.pathProgress);
        break;
      case 4:
        context.go(RouteConstants.pathProfile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(IconConstants.navigationHome),
            label: StringConstants.navigationHome,
          ),
          NavigationDestination(
            icon: Icon(IconConstants.navigationTodos),
            label: StringConstants.navigationTodos,
          ),
          NavigationDestination(
            icon: Icon(IconConstants.navigationRoutines),
            label: StringConstants.navigationRoutines,
          ),
          NavigationDestination(
            icon: Icon(IconConstants.navigationProgress),
            label: StringConstants.navigationProgress,
          ),
          NavigationDestination(
            icon: Icon(IconConstants.navigationProfile),
            label: StringConstants.navigationProfile,
          ),
        ],
      ),
    );
  }
}
