import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebisu/application.dart';
import 'package:ebisu/shared/services/database_service.dart';
import 'package:ebisu/features/profile/providers/player_profile_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await DatabaseService.initialize();
  
  // Sync any out-of-sync category ability indexes from skills
  await PlayerProfileController.syncAllCategoryAbilities();
  
  // Check and update streak on app startup
  await PlayerProfileController.checkAndUpdateStreak();
  
  runApp(
    const ProviderScope(
      child: EbisuApplication(),
    ),
  );
}
