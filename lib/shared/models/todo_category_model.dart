import 'package:isar/isar.dart';

part 'todo_category_model.g.dart';

@collection
class TodoCategory {
  Id id = Isar.autoIncrement;

  late String name;

  late int iconCodePoint;

  late int colorValue;

  /// The ability index (0-5) this category contributes to.
  /// 0=Strength, 1=Dexterity, 2=Constitution, 3=Intelligence, 4=Wisdom, 5=Charisma
  int abilityIndex = 0;

  @Index()
  late DateTime createdAt;
}
