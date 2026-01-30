import 'package:isar/isar.dart';

part 'achievement_model.g.dart';

@collection
class Achievement {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String key;

  late String name;

  late String description;

  late int iconCodePoint;

  String iconEmoji = '🏆';

  DateTime? unlockedAt;

  late bool isUnlocked;
}
