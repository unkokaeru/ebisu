/// Route constants for the entire application.
/// All route paths and names should be defined here.
class RouteConstants {
  RouteConstants._();

  // Route Paths
  static const String pathOnboarding = '/onboarding';
  static const String pathHome = '/home';
  static const String pathTodos = '/todos';
  static const String pathTodoDetail = '/todos/:id';
  static const String pathTodoAdd = '/todos/add';
  static const String pathTodoEdit = '/todos/edit/:id';
  static const String pathPickerWheel = '/todos/wheel';
  static const String pathRoutines = '/routines';
  static const String pathRoutineEdit = '/routines/:type/edit';
  static const String pathProgress = '/progress';
  static const String pathOrganizationDetail = '/progress/:id';
  static const String pathOrganizationAdd = '/progress/add';
  static const String pathOrganizationEdit = '/progress/edit/:id';
  static const String pathProfile = '/profile';
  static const String pathAchievements = '/profile/achievements';
  static const String pathSkills = '/profile/skills';
  static const String pathSettings = '/settings';

  // Route Names
  static const String nameOnboarding = 'onboarding';
  static const String nameHome = 'home';
  static const String nameTodos = 'todos';
  static const String nameTodoDetail = 'todoDetail';
  static const String nameTodoAdd = 'todoAdd';
  static const String nameTodoEdit = 'todoEdit';
  static const String namePickerWheel = 'pickerWheel';
  static const String nameRoutines = 'routines';
  static const String nameRoutineEdit = 'routineEdit';
  static const String nameProgress = 'progress';
  static const String nameOrganizationDetail = 'organizationDetail';
  static const String nameOrganizationAdd = 'organizationAdd';
  static const String nameOrganizationEdit = 'organizationEdit';
  static const String nameProfile = 'profile';
  static const String nameAchievements = 'achievements';
  static const String nameSkills = 'skills';
  static const String nameSettings = 'settings';

  // Shell Route Paths (for bottom navigation)
  static const String shellHome = '/home';
  static const String shellTodos = '/todos';
  static const String shellRoutines = '/routines';
  static const String shellProgress = '/progress';
  static const String shellProfile = '/profile';
}
