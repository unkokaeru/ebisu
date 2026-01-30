import 'package:isar/isar.dart';

part 'routine_item_model.g.dart';

enum RoutineType {
  morning,
  evening,
}

@collection
class RoutineItem {
  Id id = Isar.autoIncrement;

  @enumerated
  late RoutineType routineType;

  late String name;

  late int orderIndex;

  /// The ability index (0-5) this routine item contributes to.
  /// 0=Strength, 1=Dexterity, 2=Constitution, 3=Intelligence, 4=Wisdom, 5=Charisma
  int abilityIndex = 0;

  @Index()
  late DateTime createdAt;
}
