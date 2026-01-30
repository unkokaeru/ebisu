import 'package:isar/isar.dart';

part 'skill_model.g.dart';

@collection
class Skill {
  Id id = Isar.autoIncrement;

  late String name;

  String description = '';

  late int iconCodePoint;

  late int colorValue;

  late int experiencePoints;

  /// The ability index (0-5) this skill contributes to.
  /// 0=Strength, 1=Dexterity, 2=Constitution, 3=Intelligence, 4=Wisdom, 5=Charisma
  int abilityIndex = 0;

  @Index()
  late String sourceType;

  @Index()
  late int sourceId;

  @Index()
  late DateTime createdAt;
}
