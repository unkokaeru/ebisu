import 'package:isar/isar.dart';

part 'todo_model.g.dart';

@collection
class Todo {
  Id id = Isar.autoIncrement;

  late String title;

  int? categoryId;

  @Index()
  late int quadrant;

  late int weight;

  @Index()
  late bool isCompleted;

  @Index()
  late DateTime createdAt;

  DateTime? completedAt;

  bool isCarriedOver = false;
}
