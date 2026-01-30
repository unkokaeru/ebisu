import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebisu/core/configuration/string_constants.dart';
import 'package:ebisu/core/configuration/numeric_constants.dart';
import 'package:ebisu/core/configuration/icon_constants.dart';
import 'package:ebisu/core/configuration/color_constants.dart';
import 'package:ebisu/features/routines/providers/routine_provider.dart';
import 'package:ebisu/shared/models/routine_item_model.dart';

class RoutineEditScreen extends ConsumerStatefulWidget {
  final String routineType;

  const RoutineEditScreen({super.key, required this.routineType});

  @override
  ConsumerState<RoutineEditScreen> createState() => _RoutineEditScreenState();
}

class _RoutineEditScreenState extends ConsumerState<RoutineEditScreen> {
  RoutineType get _routineType =>
      widget.routineType == 'morning' ? RoutineType.morning : RoutineType.evening;

  void _showAddItemDialog() {
    final nameController = TextEditingController();
    int selectedAbilityIndex = 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text(StringConstants.routinesAddItem),
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
                    labelText: StringConstants.routinesItemName,
                    hintText: StringConstants.routinesItemNameHint,
                  ),
                  maxLength: NumericConstants.routineItemMaxLength,
                  textCapitalization: TextCapitalization.sentences,
                  autofocus: true,
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
                  await RoutineController.createRoutineItem(
                    routineType: _routineType,
                    name: nameController.text.trim(),
                    abilityIndex: selectedAbilityIndex,
                  );
                  if (mounted) {
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

  @override
  Widget build(BuildContext context) {
    final itemsProvider = _routineType == RoutineType.morning
        ? morningRoutineItemsProvider
        : eveningRoutineItemsProvider;
    final items = ref.watch(itemsProvider).valueOrNull ?? [];

    final isMorning = _routineType == RoutineType.morning;
    final title = isMorning
        ? StringConstants.routinesMorning
        : StringConstants.routinesEvening;

    return Scaffold(
      appBar: AppBar(
        title: Text('$title - ${StringConstants.edit}'),
        actions: [
          IconButton(
            icon: const Icon(IconConstants.actionAdd),
            onPressed: _showAddItemDialog,
          ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    StringConstants.routinesNoItems,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  const SizedBox(height: NumericConstants.paddingMedium),
                  ElevatedButton.icon(
                    onPressed: _showAddItemDialog,
                    icon: const Icon(IconConstants.actionAdd),
                    label: const Text(StringConstants.routinesAddItem),
                  ),
                ],
              ),
            )
          : ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(
                      horizontal: NumericConstants.paddingMedium,
                    ),
                    itemCount: items.length,
                    onReorder: (oldIndex, newIndex) async {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final reorderedItems = List<RoutineItem>.from(items);
                      final movedItem = reorderedItems.removeAt(oldIndex);
                      reorderedItems.insert(newIndex, movedItem);
                      await RoutineController.reorderRoutineItems(reorderedItems);
                    },
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final safeAbilityIdx = NumericConstants.safeAbilityIndex(item.abilityIndex);
                      final abilityColor = ColorConstants.abilityColors[safeAbilityIdx];
                      return Card(
                        key: ValueKey(item.id),
                        child: ListTile(
                          leading: const Icon(IconConstants.drag),
                          title: Text(item.name),
                          subtitle: Row(
                            children: [
                              Icon(
                                IconConstants.abilityIcons[safeAbilityIdx],
                                size: NumericConstants.iconSizeTiny,
                                color: abilityColor,
                              ),
                              const SizedBox(width: NumericConstants.paddingTiny),
                              Text(
                                StringConstants.abilityNames[safeAbilityIdx],
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: abilityColor,
                                      fontSize: 10,
                                    ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(IconConstants.actionEdit),
                                onPressed: () => _showEditDialog(item),
                              ),
                              IconButton(
                                icon: const Icon(IconConstants.actionDelete),
                                onPressed: () => _confirmDelete(item),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
    );
  }

  void _showEditDialog(RoutineItem item) {
    final controller = TextEditingController(text: item.name);
    int selectedAbilityIndex = NumericConstants.safeAbilityIndex(item.abilityIndex);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text(StringConstants.routinesEditItem),
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
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: StringConstants.routinesItemName,
                  ),
                  maxLength: NumericConstants.routineItemMaxLength,
                  autofocus: true,
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
                if (controller.text.trim().isNotEmpty) {
                  item.name = controller.text.trim();
                  item.abilityIndex = selectedAbilityIndex;
                  await RoutineController.updateRoutineItem(item);
                  if (mounted) Navigator.pop(context);
                }
              },
              child: const Text(StringConstants.save),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(RoutineItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(StringConstants.routinesDeleteItem),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(StringConstants.cancel),
          ),
          TextButton(
            onPressed: () async {
              await RoutineController.deleteRoutineItem(item.id);
              if (mounted) Navigator.pop(context);
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
