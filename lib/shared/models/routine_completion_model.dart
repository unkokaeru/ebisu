import 'package:isar/isar.dart';

part 'routine_completion_model.g.dart';

@collection
class RoutineCompletion {
  Id id = Isar.autoIncrement;

  @Index()
  late int routineType;

  @Index()
  late DateTime date;

  late List<int> completedItemIds;

  late bool isFullyCompleted;
}
