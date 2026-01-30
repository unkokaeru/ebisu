import 'package:isar/isar.dart';

part 'player_profile_model.g.dart';

@collection
class PlayerProfile {
  Id id = Isar.autoIncrement;

  late String playerName;

  late int totalExperiencePoints;

  late int currentStreak;

  late int longestStreak;

  late DateTime lastActiveDate;

  late DateTime createdAt;

  late int totalTasksCompleted;

  late int totalRoutinesCompleted;

  late int urgentImportantTasksCompleted;
}
