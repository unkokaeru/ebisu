import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:ebisu/core/configuration/string_constants.dart';
import 'package:ebisu/core/configuration/numeric_constants.dart';
import 'package:ebisu/core/configuration/icon_constants.dart';
import 'package:ebisu/core/configuration/color_constants.dart';
import 'package:ebisu/core/configuration/route_constants.dart';
import 'package:ebisu/features/todos/providers/todo_provider.dart';
import 'package:ebisu/shared/models/todo_model.dart';
import 'package:ebisu/shared/widgets/empty_state_widget.dart';
import 'package:ebisu/shared/widgets/animated_checkbox.dart';

class TodosScreen extends ConsumerStatefulWidget {
  const TodosScreen({super.key});

  @override
  ConsumerState<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends ConsumerState<TodosScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? _selectedCategoryFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeTodos = ref.watch(activeTodosProvider);
    final completedTodos = ref.watch(completedTodosProvider);
    final categories = ref.watch(todoCategoriesProvider).valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.todosTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: '${StringConstants.todosFilterActive} (${activeTodos.length})'),
            Tab(text: '${StringConstants.todosCompleted} (${completedTodos.length})'),
          ],
        ),
        actions: [
          if (categories.isNotEmpty)
            PopupMenuButton<int?>(
              icon: Icon(
                IconConstants.actionFilter,
                color: _selectedCategoryFilter != null
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              onSelected: (value) {
                setState(() {
                  _selectedCategoryFilter = value;
                });
              },
              itemBuilder: (context) => [
                PopupMenuItem<int?>(
                  value: null,
                  child: Row(
                    children: [
                      Icon(
                        _selectedCategoryFilter == null
                            ? Icons.check_rounded
                            : null,
                        size: NumericConstants.iconSizeSmall,
                      ),
                      const SizedBox(width: NumericConstants.paddingSmall),
                      Text(StringConstants.todosFilterAll),
                    ],
                  ),
                ),
                ...categories.map(
                  (category) => PopupMenuItem<int?>(
                    value: category.id,
                    child: Row(
                      children: [
                        Icon(
                          IconData(category.iconCodePoint, fontFamily: 'MaterialIcons'),
                          color: Color(category.colorValue),
                          size: NumericConstants.iconSizeSmall,
                        ),
                        const SizedBox(width: NumericConstants.paddingSmall),
                        Text(category.name),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMatrixView(activeTodos, categories),
          _buildCompletedList(completedTodos, categories),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'wheel',
            onPressed: () => context.push('${RouteConstants.pathTodos}/wheel'),
            child: const Icon(IconConstants.actionSpin)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .rotate(begin: -0.05, end: 0.05, duration: const Duration(seconds: 2)),
          ).animate().fadeIn().scale(),
          const SizedBox(height: NumericConstants.paddingSmall),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () => context.push('${RouteConstants.pathTodos}/add'),
            child: const Icon(IconConstants.actionAdd),
          )
              .animate().fadeIn(delay: const Duration(milliseconds: 100)).scale()
              .then()
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.05, 1.05),
                duration: const Duration(seconds: 2),
              ),
        ],
      ),
    );
  }

  Widget _buildMatrixView(List<Todo> todos, List categories) {
    final filteredTodos = _selectedCategoryFilter == null
        ? todos
        : todos.where((t) => t.categoryId == _selectedCategoryFilter).toList();

    if (filteredTodos.isEmpty) {
      return EmptyStateWidget(
        icon: IconConstants.empty,
        title: StringConstants.todosNoTasks,
        subtitle: StringConstants.todosAddFirstTask,
      );
    }

    final quadrant1 = filteredTodos.where((t) => t.quadrant == NumericConstants.quadrantUrgentImportant).toList();
    final quadrant2 = filteredTodos.where((t) => t.quadrant == NumericConstants.quadrantImportantNotUrgent).toList();
    final quadrant3 = filteredTodos.where((t) => t.quadrant == NumericConstants.quadrantUrgentNotImportant).toList();
    final quadrant4 = filteredTodos.where((t) => t.quadrant == NumericConstants.quadrantNotUrgentNotImportant).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(NumericConstants.paddingSmall),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildQuadrantCard(
                  title: StringConstants.quadrantUrgentImportant,
                  subtitle: StringConstants.quadrantUrgentImportantDescription,
                  color: ColorConstants.quadrantUrgentImportant,
                  todos: quadrant1,
                  quadrant: NumericConstants.quadrantUrgentImportant,
                  categories: categories,
                ).animate().fadeIn().slideX(begin: -0.1, end: 0),
              ),
              const SizedBox(width: NumericConstants.paddingSmall),
              Expanded(
                child: _buildQuadrantCard(
                  title: StringConstants.quadrantImportantNotUrgent,
                  subtitle: StringConstants.quadrantImportantNotUrgentDescription,
                  color: ColorConstants.quadrantImportantNotUrgent,
                  todos: quadrant2,
                  quadrant: NumericConstants.quadrantImportantNotUrgent,
                  categories: categories,
                ).animate().fadeIn(delay: const Duration(milliseconds: 100)).slideX(begin: 0.1, end: 0),
              ),
            ],
          ),
          const SizedBox(height: NumericConstants.paddingSmall),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildQuadrantCard(
                  title: StringConstants.quadrantUrgentNotImportant,
                  subtitle: StringConstants.quadrantUrgentNotImportantDescription,
                  color: ColorConstants.quadrantUrgentNotImportant,
                  todos: quadrant3,
                  quadrant: NumericConstants.quadrantUrgentNotImportant,
                  categories: categories,
                ).animate().fadeIn(delay: const Duration(milliseconds: 200)).slideX(begin: -0.1, end: 0),
              ),
              const SizedBox(width: NumericConstants.paddingSmall),
              Expanded(
                child: _buildQuadrantCard(
                  title: StringConstants.quadrantNotUrgentNotImportant,
                  subtitle: StringConstants.quadrantNotUrgentNotImportantDescription,
                  color: ColorConstants.quadrantNotUrgentNotImportant,
                  todos: quadrant4,
                  quadrant: NumericConstants.quadrantNotUrgentNotImportant,
                  categories: categories,
                ).animate().fadeIn(delay: const Duration(milliseconds: 300)).slideX(begin: 0.1, end: 0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuadrantCard({
    required String title,
    required String subtitle,
    required Color color,
    required List<Todo> todos,
    required int quadrant,
    required List categories,
  }) {
    return Card(
      child: Container(
        constraints: const BoxConstraints(minHeight: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(NumericConstants.paddingSmall),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(NumericConstants.borderRadiusMedium),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: color.withOpacity(0.8),
                          fontSize: 10,
                        ),
                  ),
                ],
              ),
            ),
            if (todos.isEmpty)
              Padding(
                padding: const EdgeInsets.all(NumericConstants.paddingMedium),
                child: Center(
                  child: Text(
                    StringConstants.todosNoTasks,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ),
              )
            else
              ...todos.map((todo) => _buildTodoTile(todo, color, categories)),
          ],
        ),
      ),
    );
  }

  Widget _buildTodoTile(Todo todo, Color quadrantColor, List categories) {
    final category = todo.categoryId != null
        ? categories.cast<dynamic>().firstWhere(
              (c) => c.id == todo.categoryId,
              orElse: () => null,
            )
        : null;
    final abilityIndex = NumericConstants.safeAbilityIndex(category?.abilityIndex ?? 0);
    final abilityColor = ColorConstants.abilityColors[abilityIndex];

    return InkWell(
      onTap: () => context.push('${RouteConstants.pathTodos}/edit/${todo.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: NumericConstants.paddingSmall,
          vertical: NumericConstants.paddingTiny,
        ),
        child: Row(
          children: [
            AnimatedCheckbox(
              value: todo.isCompleted,
              activeColor: quadrantColor,
              onChanged: (value) async {
                if (value) {
                  await TodoController.completeTodo(todo);
                } else {
                  await TodoController.uncompleteTodo(todo);
                }
              },
            ),
            const SizedBox(width: NumericConstants.paddingSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      if (category != null) ...[
                        Icon(
                          IconConstants.abilityIcons[abilityIndex],
                          size: 10,
                          color: abilityColor,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          StringConstants.abilityNames[abilityIndex],
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: abilityColor,
                                fontSize: 9,
                              ),
                        ),
                        const SizedBox(width: NumericConstants.paddingSmall),
                      ],
                      if (todo.isCarriedOver)
                        Text(
                          StringConstants.organizationCarriedOver,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontSize: 9,
                              ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: NumericConstants.paddingTiny,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: quadrantColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${todo.weight}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: quadrantColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedList(List<Todo> todos, List categories) {
    final filteredTodos = _selectedCategoryFilter == null
        ? todos
        : todos.where((t) => t.categoryId == _selectedCategoryFilter).toList();

    if (filteredTodos.isEmpty) {
      return EmptyStateWidget(
        icon: IconConstants.statusComplete,
        title: StringConstants.todosNoTasks,
        subtitle: 'Complete some tasks to see them here',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(NumericConstants.paddingMedium),
      itemCount: filteredTodos.length,
      itemBuilder: (context, index) {
        final todo = filteredTodos[index];
        final quadrantColor = _getQuadrantColor(todo.quadrant);
        final category = todo.categoryId != null
            ? categories.cast<dynamic>().firstWhere(
                  (c) => c.id == todo.categoryId,
                  orElse: () => null,
                )
            : null;
        final abilityIndex = NumericConstants.safeAbilityIndex(category?.abilityIndex ?? 0);
        final abilityColor = ColorConstants.abilityColors[abilityIndex];

        return Card(
          child: ListTile(
            leading: AnimatedCheckbox(
              value: todo.isCompleted,
              activeColor: quadrantColor,
              onChanged: (value) async {
                if (!value) {
                  await TodoController.uncompleteTodo(todo);
                }
              },
            ),
            title: Text(
              todo.title,
              style: const TextStyle(decoration: TextDecoration.lineThrough),
            ),
            subtitle: category != null
                ? Row(
                    children: [
                      Icon(
                        IconConstants.abilityIcons[abilityIndex],
                        size: 10,
                        color: abilityColor,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        StringConstants.abilityNames[abilityIndex],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: abilityColor,
                              fontSize: 9,
                            ),
                      ),
                    ],
                  )
                : null,
            trailing: IconButton(
              icon: const Icon(IconConstants.actionDelete),
              onPressed: () => _confirmDelete(todo),
            ),
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: index * 50));
      },
    );
  }

  Color _getQuadrantColor(int quadrant) {
    switch (quadrant) {
      case NumericConstants.quadrantUrgentImportant:
        return ColorConstants.quadrantUrgentImportant;
      case NumericConstants.quadrantImportantNotUrgent:
        return ColorConstants.quadrantImportantNotUrgent;
      case NumericConstants.quadrantUrgentNotImportant:
        return ColorConstants.quadrantUrgentNotImportant;
      default:
        return ColorConstants.quadrantNotUrgentNotImportant;
    }
  }

  void _confirmDelete(Todo todo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(StringConstants.todosDeleteTask),
        content: const Text(StringConstants.todosConfirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(StringConstants.cancel),
          ),
          TextButton(
            onPressed: () {
              TodoController.deleteTodo(todo.id);
              Navigator.pop(context);
            },
            child: Text(
              StringConstants.delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
