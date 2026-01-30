import 'package:isar/isar.dart';

part 'organization_category_model.g.dart';

@collection
class OrganizationCategory {
  Id id = Isar.autoIncrement;

  late String name;

  late int iconCodePoint;

  late int colorValue;

  late List<String> levels;

  /// The ability index (0-5) this skill contributes to.
  /// 0=Strength, 1=Dexterity, 2=Constitution, 3=Intelligence, 4=Wisdom, 5=Charisma
  late int abilityIndex;

  @Index()
  late DateTime createdAt;
}
