import 'package:isar/isar.dart';

part 'daily_organization_log_model.g.dart';

@collection
class DailyOrganizationLog {
  Id id = Isar.autoIncrement;

  @Index()
  late int categoryId;

  @Index()
  late DateTime date;

  late int completedLevel;

  bool isCarriedOver = false;
}
