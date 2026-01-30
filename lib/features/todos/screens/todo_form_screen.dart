import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ebisu/core/configuration/string_constants.dart';
import 'package:ebisu/core/configuration/numeric_constants.dart';
import 'package:ebisu/core/configuration/icon_constants.dart';
import 'package:ebisu/core/configuration/color_constants.dart';
import 'package:ebisu/features/todos/providers/todo_provider.dart';
import 'package:ebisu/shared/models/todo_model.dart';
import 'package:ebisu/shared/services/database_service.dart';

class TodoFormScreen extends ConsumerStatefulWidget {
  final int? todoId;

  const TodoFormScreen({super.key, this.todoId});

  @override
  ConsumerState<TodoFormScreen> createState() => _TodoFormScreenState();
}

class _TodoFormScreenState extends ConsumerState<TodoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  int _selectedQuadrant = NumericConstants.quadrantUrgentImportant;
  int? _selectedCategoryId;

  int get _weight => _calculateWeightFromQuadrant(_selectedQuadrant);

  static int _calculateWeightFromQuadrant(int quadrant) {
    switch (quadrant) {
      case NumericConstants.quadrantUrgentImportant:
        return NumericConstants.todoWeightMax;
      case NumericConstants.quadrantImportantNotUrgent:
        return 7;
      case NumericConstants.quadrantUrgentNotImportant:
        return 4;
      default:
        return NumericConstants.todoWeightMin;
    }
  }

  bool _isLoading = false;
  bool _isEditMode = false;
  Todo? _existingTodo;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.todoId != null;
    if (_isEditMode) {
      _loadTodo();
    }
  }

  Future<void> _loadTodo() async {
    setState(() => _isLoading = true);

    final todo = await DatabaseService.instance.todos.get(widget.todoId!);
    if (todo != null) {
      _existingTodo = todo;
      _titleController.text = todo.title;
      _selectedQuadrant = todo.quadrant;
      _selectedCategoryId = todo.categoryId;
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isEditMode && _existingTodo != null) {
        _existingTodo!
          ..title = _titleController.text.trim()
          ..quadrant = _selectedQuadrant
          ..weight = _weight
          ..categoryId = _selectedCategoryId;

        await TodoController.updateTodo(_existingTodo!);
      } else {
        await TodoController.createTodo(
          title: _titleController.text.trim(),
          quadrant: _selectedQuadrant,
          weight: _weight,
          categoryId: _selectedCategoryId,
        );
      }

      if (mounted) {
        context.pop();
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(StringConstants.todosDeleteTask),
        content: const Text(StringConstants.todosConfirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(StringConstants.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              StringConstants.delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && widget.todoId != null) {
      await TodoController.deleteTodo(widget.todoId!);
      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(todoCategoriesProvider).valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? StringConstants.todosEditTask : StringConstants.todosAddTask),
        actions: [
          if (_isEditMode)
            IconButton(
              icon: const Icon(IconConstants.actionDelete),
              onPressed: _delete,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(NumericConstants.paddingMedium),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: StringConstants.todosTaskTitle,
                        hintText: StringConstants.todosTaskTitleHint,
                      ),
                      maxLength: NumericConstants.taskTitleMaxLength,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return StringConstants.todosTaskTitleValidation;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: NumericConstants.paddingMedium),
                    Text(
                      StringConstants.todosQuadrant,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: NumericConstants.paddingSmall),
                    _buildQuadrantSelector(),
                    const SizedBox(height: NumericConstants.paddingMedium),
                    Text(
                      StringConstants.todosCategory,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: NumericConstants.paddingSmall),
                    _buildCategorySelector(categories),
                    const SizedBox(height: NumericConstants.paddingLarge),
                    ElevatedButton(
                      onPressed: _save,
                      child: Text(_isEditMode ? StringConstants.save : StringConstants.add),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildQuadrantSelector() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _QuadrantOption(
                title: StringConstants.quadrantUrgentImportant,
                color: ColorConstants.quadrantUrgentImportant,
                isSelected: _selectedQuadrant == NumericConstants.quadrantUrgentImportant,
                onTap: () => setState(() => _selectedQuadrant = NumericConstants.quadrantUrgentImportant),
              ),
            ),
            const SizedBox(width: NumericConstants.paddingSmall),
            Expanded(
              child: _QuadrantOption(
                title: StringConstants.quadrantImportantNotUrgent,
                color: ColorConstants.quadrantImportantNotUrgent,
                isSelected: _selectedQuadrant == NumericConstants.quadrantImportantNotUrgent,
                onTap: () => setState(() => _selectedQuadrant = NumericConstants.quadrantImportantNotUrgent),
              ),
            ),
          ],
        ),
        const SizedBox(height: NumericConstants.paddingSmall),
        Row(
          children: [
            Expanded(
              child: _QuadrantOption(
                title: StringConstants.quadrantUrgentNotImportant,
                color: ColorConstants.quadrantUrgentNotImportant,
                isSelected: _selectedQuadrant == NumericConstants.quadrantUrgentNotImportant,
                onTap: () => setState(() => _selectedQuadrant = NumericConstants.quadrantUrgentNotImportant),
              ),
            ),
            const SizedBox(width: NumericConstants.paddingSmall),
            Expanded(
              child: _QuadrantOption(
                title: StringConstants.quadrantNotUrgentNotImportant,
                color: ColorConstants.quadrantNotUrgentNotImportant,
                isSelected: _selectedQuadrant == NumericConstants.quadrantNotUrgentNotImportant,
                onTap: () => setState(() => _selectedQuadrant = NumericConstants.quadrantNotUrgentNotImportant),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategorySelector(List categories) {
    return Wrap(
      spacing: NumericConstants.paddingSmall,
      runSpacing: NumericConstants.paddingSmall,
      children: [
        ChoiceChip(
          label: const Text('None'),
          selected: _selectedCategoryId == null,
          onSelected: (_) => setState(() => _selectedCategoryId = null),
        ),
        ...categories.map(
          (category) {
            final safeAbilityIdx = NumericConstants.safeAbilityIndex(category.abilityIndex);
            return GestureDetector(
              onLongPress: () => _showEditCategoryDialog(category),
              child: ChoiceChip(
                avatar: Icon(
                  IconData(category.iconCodePoint, fontFamily: 'MaterialIcons'),
                  color: Color(category.colorValue),
                  size: NumericConstants.iconSizeSmall,
                ),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(category.name),
                    const SizedBox(width: 4),
                    Icon(
                      IconConstants.abilityIcons[safeAbilityIdx],
                      size: 12,
                      color: ColorConstants.abilityColors[safeAbilityIdx],
                    ),
                  ],
                ),
                selected: _selectedCategoryId == category.id,
                onSelected: (_) => setState(() => _selectedCategoryId = category.id),
              ),
            );
          },
        ),
        ActionChip(
          avatar: const Icon(IconConstants.actionAdd, size: NumericConstants.iconSizeSmall),
          label: const Text(StringConstants.add),
          onPressed: _showAddCategoryDialog,
        ),
      ],
    );
  }

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();
    int selectedIconIndex = 0;
    int selectedColorIndex = 0;
    int selectedAbilityIndex = 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Category'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ability Selection
                const Text('Ability'),
                const SizedBox(height: NumericConstants.paddingSmall),
                Wrap(
                  spacing: NumericConstants.paddingTiny,
                  runSpacing: NumericConstants.paddingTiny,
                  children: List.generate(
                    NumericConstants.abilityCount,
                    (index) => ChoiceChip(
                      label: Text(StringConstants.abilityNames[index]),
                      selected: selectedAbilityIndex == index,
                      selectedColor: ColorConstants.abilityColors[index],
                      onSelected: (selected) {
                        if (selected) {
                          setDialogState(() => selectedAbilityIndex = index);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: NumericConstants.paddingMedium),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                  ),
                  maxLength: NumericConstants.categoryNameMaxLength,
                ),
                const SizedBox(height: NumericConstants.paddingMedium),
                const Text('Icon'),
                const SizedBox(height: NumericConstants.paddingSmall),
                Wrap(
                  spacing: NumericConstants.paddingSmall,
                  runSpacing: NumericConstants.paddingSmall,
                  children: List.generate(
                    IconConstants.categoryIcons.length,
                    (index) => GestureDetector(
                      onTap: () => setDialogState(() => selectedIconIndex = index),
                      child: Container(
                        padding: const EdgeInsets.all(NumericConstants.paddingSmall),
                        decoration: BoxDecoration(
                          color: selectedIconIndex == index
                              ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                              : null,
                          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusSmall),
                          border: selectedIconIndex == index
                              ? Border.all(color: Theme.of(context).colorScheme.primary)
                              : null,
                        ),
                        child: Icon(IconConstants.categoryIcons[index]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: NumericConstants.paddingMedium),
                const Text('Color'),
                const SizedBox(height: NumericConstants.paddingSmall),
                Wrap(
                  spacing: NumericConstants.paddingSmall,
                  runSpacing: NumericConstants.paddingSmall,
                  children: List.generate(
                    ColorConstants.categoryColors.length,
                    (index) => GestureDetector(
                      onTap: () => setDialogState(() => selectedColorIndex = index),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: ColorConstants.categoryColors[index],
                          shape: BoxShape.circle,
                          border: selectedColorIndex == index
                              ? Border.all(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  width: 3,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(StringConstants.cancel),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.trim().isNotEmpty) {
                  final category = await TodoController.createCategory(
                    name: nameController.text.trim(),
                    iconCodePoint: IconConstants.categoryIcons[selectedIconIndex].codePoint,
                    colorValue: ColorConstants.categoryColors[selectedColorIndex].value,
                    abilityIndex: selectedAbilityIndex,
                  );
                  if (mounted) {
                    setState(() => _selectedCategoryId = category.id);
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text(StringConstants.add),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditCategoryDialog(dynamic category) {
    final nameController = TextEditingController(text: category.name);
    int selectedIconIndex = IconConstants.categoryIcons
        .indexWhere((icon) => icon.codePoint == category.iconCodePoint);
    if (selectedIconIndex == -1) selectedIconIndex = 0;
    int selectedColorIndex = ColorConstants.categoryColors
        .indexWhere((color) => color.value == category.colorValue);
    if (selectedColorIndex == -1) selectedColorIndex = 0;
    int selectedAbilityIndex = NumericConstants.safeAbilityIndex(category.abilityIndex);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Category'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ability'),
                const SizedBox(height: NumericConstants.paddingSmall),
                Wrap(
                  spacing: NumericConstants.paddingTiny,
                  runSpacing: NumericConstants.paddingTiny,
                  children: List.generate(
                    NumericConstants.abilityCount,
                    (index) => ChoiceChip(
                      label: Text(StringConstants.abilityNames[index]),
                      selected: selectedAbilityIndex == index,
                      selectedColor: ColorConstants.abilityColors[index],
                      onSelected: (selected) {
                        if (selected) {
                          setDialogState(() => selectedAbilityIndex = index);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: NumericConstants.paddingMedium),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                  ),
                  maxLength: NumericConstants.categoryNameMaxLength,
                ),
                const SizedBox(height: NumericConstants.paddingMedium),
                const Text('Icon'),
                const SizedBox(height: NumericConstants.paddingSmall),
                Wrap(
                  spacing: NumericConstants.paddingSmall,
                  runSpacing: NumericConstants.paddingSmall,
                  children: List.generate(
                    IconConstants.categoryIcons.length,
                    (index) => GestureDetector(
                      onTap: () => setDialogState(() => selectedIconIndex = index),
                      child: Container(
                        padding: const EdgeInsets.all(NumericConstants.paddingSmall),
                        decoration: BoxDecoration(
                          color: selectedIconIndex == index
                              ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                              : null,
                          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusSmall),
                          border: selectedIconIndex == index
                              ? Border.all(color: Theme.of(context).colorScheme.primary)
                              : null,
                        ),
                        child: Icon(IconConstants.categoryIcons[index]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: NumericConstants.paddingMedium),
                const Text('Color'),
                const SizedBox(height: NumericConstants.paddingSmall),
                Wrap(
                  spacing: NumericConstants.paddingSmall,
                  runSpacing: NumericConstants.paddingSmall,
                  children: List.generate(
                    ColorConstants.categoryColors.length,
                    (index) => GestureDetector(
                      onTap: () => setDialogState(() => selectedColorIndex = index),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: ColorConstants.categoryColors[index],
                          shape: BoxShape.circle,
                          border: selectedColorIndex == index
                              ? Border.all(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  width: 3,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => _confirmDeleteCategory(category),
              child: Text(
                StringConstants.delete,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(StringConstants.cancel),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.trim().isNotEmpty) {
                  category.name = nameController.text.trim();
                  category.iconCodePoint = IconConstants.categoryIcons[selectedIconIndex].codePoint;
                  category.colorValue = ColorConstants.categoryColors[selectedColorIndex].value;
                  category.abilityIndex = selectedAbilityIndex;
                  await TodoController.updateCategory(category);
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text(StringConstants.save),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteCategory(dynamic category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.name}"? Tasks in this category will become uncategorized.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(StringConstants.cancel),
          ),
          TextButton(
            onPressed: () async {
              await TodoController.deleteCategory(category.id);
              if (mounted) {
                Navigator.pop(context); // Close confirm dialog
                Navigator.pop(context); // Close edit dialog
                if (_selectedCategoryId == category.id) {
                  setState(() => _selectedCategoryId = null);
                }
              }
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

class _QuadrantOption extends StatelessWidget {
  final String title;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _QuadrantOption({
    required this.title,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: NumericConstants.animationDurationFast),
        padding: const EdgeInsets.all(NumericConstants.paddingMedium),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : null,
          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
          border: Border.all(
            color: isSelected ? color : Theme.of(context).colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected ? color : null,
                fontWeight: isSelected ? FontWeight.bold : null,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
