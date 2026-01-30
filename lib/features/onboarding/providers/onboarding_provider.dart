import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ebisu/core/configuration/storage_key_constants.dart';
import 'package:ebisu/shared/services/database_service.dart';
import 'package:ebisu/shared/models/player_profile_model.dart';

final isOnboardingCompleteProvider = FutureProvider<bool>((ref) async {
  final preferences = await SharedPreferences.getInstance();
  return preferences.getBool(StorageKeyConstants.keyOnboardingComplete) ?? false;
});

final playerNameProvider = StateNotifierProvider<PlayerNameNotifier, String?>((ref) {
  return PlayerNameNotifier();
});

class PlayerNameNotifier extends StateNotifier<String?> {
  PlayerNameNotifier() : super(null) {
    _loadPlayerName();
  }

  Future<void> _loadPlayerName() async {
    final preferences = await SharedPreferences.getInstance();
    state = preferences.getString(StorageKeyConstants.keyPlayerName);
  }

  Future<void> setPlayerName(String name) async {
    state = name;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(StorageKeyConstants.keyPlayerName, name);
  }
}

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  return OnboardingController(ref);
});

class OnboardingState {
  final bool isLoading;
  final String? error;

  const OnboardingState({
    this.isLoading = false,
    this.error,
  });

  OnboardingState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return OnboardingState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class OnboardingController extends StateNotifier<OnboardingState> {
  final Ref _ref;

  OnboardingController(this._ref) : super(const OnboardingState());

  Future<bool> completeOnboarding(String playerName) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(StorageKeyConstants.keyPlayerName, playerName);
      await preferences.setBool(StorageKeyConstants.keyOnboardingComplete, true);

      final now = DateTime.now();
      final profile = PlayerProfile()
        ..playerName = playerName
        ..totalExperiencePoints = 0
        ..currentStreak = 0
        ..longestStreak = 0
        ..lastActiveDate = now
        ..createdAt = now
        ..totalTasksCompleted = 0
        ..totalRoutinesCompleted = 0
        ..urgentImportantTasksCompleted = 0;

      await DatabaseService.instance.writeTxn(() async {
        await DatabaseService.instance.playerProfiles.put(profile);
      });

      _ref.read(playerNameProvider.notifier).setPlayerName(playerName);
      _ref.invalidate(isOnboardingCompleteProvider);

      state = state.copyWith(isLoading: false);
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
      return false;
    }
  }
}
