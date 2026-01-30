import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ebisu/core/configuration/string_constants.dart';
import 'package:ebisu/core/configuration/numeric_constants.dart';
import 'package:ebisu/core/configuration/icon_constants.dart';
import 'package:ebisu/core/configuration/color_constants.dart';
import 'package:ebisu/features/progress/providers/organization_provider.dart';
import 'package:ebisu/shared/models/organization_category_model.dart';
import 'package:ebisu/shared/services/database_service.dart';

class OrganizationFormScreen extends ConsumerStatefulWidget {
  final int? categoryId;

  const OrganizationFormScreen({super.key, this.categoryId});

  @override
  ConsumerState<OrganizationFormScreen> createState() => _OrganizationFormScreenState();
}

class _OrganizationFormScreenState extends ConsumerState<OrganizationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final List<TextEditingController> _levelControllers = List.generate(
    NumericConstants.organizationMaxLevel,
    (_) => TextEditingController(),
  );

  int _selectedIconIndex = 0;
  int _selectedColorIndex = 0;
  int _selectedAbilityIndex = 0;
  bool _isLoading = false;
  bool _isEditMode = false;
  OrganizationCategory? _existingCategory;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.categoryId != null;
    if (_isEditMode) {
      _loadCategory();
    }
  }

  Future<void> _loadCategory() async {
    setState(() => _isLoading = true);

    final category = await DatabaseService.instance.organizationCategorys.get(widget.categoryId!);
    if (category != null) {
      _existingCategory = category;
      _nameController.text = category.name;
      _selectedAbilityIndex = NumericConstants.safeAbilityIndex(category.abilityIndex);

      _selectedIconIndex = IconConstants.categoryIcons.indexWhere(
        (icon) => icon.codePoint == category.iconCodePoint,
      );
      if (_selectedIconIndex < 0) _selectedIconIndex = 0;

      _selectedColorIndex = ColorConstants.categoryColors.indexWhere(
        (color) => color.value == category.colorValue,
      );
      if (_selectedColorIndex < 0) _selectedColorIndex = 0;

      for (int i = 0; i < category.levels.length && i < _levelControllers.length; i++) {
        _levelControllers[i].text = category.levels[i];
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (final controller in _levelControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final levels = _levelControllers.map((c) => c.text.trim()).toList();
    if (levels.any((l) => l.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(StringConstants.organizationLevelValidation)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isEditMode && _existingCategory != null) {
        _existingCategory!
          ..name = _nameController.text.trim()
          ..iconCodePoint = IconConstants.categoryIcons[_selectedIconIndex].codePoint
          ..colorValue = ColorConstants.categoryColors[_selectedColorIndex].value
          ..abilityIndex = _selectedAbilityIndex
          ..levels = levels;

        await OrganizationController.updateCategory(_existingCategory!);
      } else {
        await OrganizationController.createCategory(
          name: _nameController.text.trim(),
          iconCodePoint: IconConstants.categoryIcons[_selectedIconIndex].codePoint,
          colorValue: ColorConstants.categoryColors[_selectedColorIndex].value,
          abilityIndex: _selectedAbilityIndex,
          levels: levels,
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
        title: const Text(StringConstants.organizationDeleteCategory),
        content: const Text('Are you sure? All history will be lost.'),
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

    if (confirmed == true && widget.categoryId != null) {
      await OrganizationController.deleteCategory(widget.categoryId!);
      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode
            ? StringConstants.organizationEditCategory
            : StringConstants.organizationAddCategory),
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
                    // Ability Selection (like quadrant picker in todos)
                    Text(
                      StringConstants.organizationSelectAbility,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: NumericConstants.paddingSmall),
                    Wrap(
                      spacing: NumericConstants.paddingSmall,
                      runSpacing: NumericConstants.paddingSmall,
                      children: List.generate(
                        NumericConstants.abilityCount,
                        (index) => ChoiceChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                IconConstants.abilityIcons[index],
                                size: NumericConstants.iconSizeSmall,
                                color: _selectedAbilityIndex == index
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : ColorConstants.abilityColors[index],
                              ),
                              const SizedBox(width: NumericConstants.paddingTiny),
                              Text(StringConstants.abilityNames[index]),
                            ],
                          ),
                          selected: _selectedAbilityIndex == index,
                          selectedColor: ColorConstants.abilityColors[index],
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedAbilityIndex = index);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: NumericConstants.paddingLarge),
                    // Skill Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: StringConstants.organizationCategoryName,
                        hintText: StringConstants.organizationCategoryNameHint,
                      ),
                      maxLength: NumericConstants.categoryNameMaxLength,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return StringConstants.organizationCategoryNameValidation;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: NumericConstants.paddingMedium),
                    Text(
                      'Icon',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: NumericConstants.paddingSmall),
                    Wrap(
                      spacing: NumericConstants.paddingSmall,
                      runSpacing: NumericConstants.paddingSmall,
                      children: List.generate(
                        IconConstants.categoryIcons.length,
                        (index) => GestureDetector(
                          onTap: () => setState(() => _selectedIconIndex = index),
                          child: Container(
                            padding: const EdgeInsets.all(NumericConstants.paddingSmall),
                            decoration: BoxDecoration(
                              color: _selectedIconIndex == index
                                  ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                                  : null,
                              borderRadius: BorderRadius.circular(NumericConstants.borderRadiusSmall),
                              border: _selectedIconIndex == index
                                  ? Border.all(color: Theme.of(context).colorScheme.primary)
                                  : null,
                            ),
                            child: Icon(IconConstants.categoryIcons[index]),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: NumericConstants.paddingMedium),
                    Text(
                      'Color',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: NumericConstants.paddingSmall),
                    Wrap(
                      spacing: NumericConstants.paddingSmall,
                      runSpacing: NumericConstants.paddingSmall,
                      children: List.generate(
                        ColorConstants.categoryColors.length,
                        (index) => GestureDetector(
                          onTap: () => setState(() => _selectedColorIndex = index),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: ColorConstants.categoryColors[index],
                              shape: BoxShape.circle,
                              border: _selectedColorIndex == index
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
                    const SizedBox(height: NumericConstants.paddingLarge),
                    Text(
                      '${StringConstants.organizationLevels} (1-${NumericConstants.organizationMaxLevel})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: NumericConstants.paddingSmall),
                    ...List.generate(
                      NumericConstants.organizationMaxLevel,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: NumericConstants.paddingSmall),
                        child: TextFormField(
                          controller: _levelControllers[index],
                          decoration: InputDecoration(
                            labelText: '${StringConstants.organizationLevelHint} ${index + 1}',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: NumericConstants.paddingMedium),
                              child: Container(
                                width: 20,
                                height: 20,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: ColorConstants.categoryColors[_selectedColorIndex],
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ),
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 48,
                              minHeight: 20,
                            ),
                          ),
                          maxLength: NumericConstants.levelDescriptionMaxLength,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                    ),
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
}
