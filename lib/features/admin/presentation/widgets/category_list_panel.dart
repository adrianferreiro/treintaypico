import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/styles/app_colors.dart';
import 'package:treintaypico/features/admin/presentation/widgets/category_form_dialog.dart';
import 'package:treintaypico/features/categories/application/providers/category_providers.dart';
import 'package:treintaypico/features/categories/application/states/category_state.dart';
import 'package:treintaypico/features/categories/domain/entities/category_entity.dart';

class CategoryListPanel extends ConsumerWidget {
  final CategoryState categoryState;
  final CategoryEntity? selectedCategory;
  final ValueChanged<CategoryEntity> onCategorySelected;
  final VoidCallback onCategoriesChanged;

  const CategoryListPanel({
    super.key,
    required this.categoryState,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onCategoriesChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 360,
      color: AppColors.darkBackground,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Text(
                'Categorías',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _showCreateDialog(context, ref),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Category List
          Expanded(
            child: switch (categoryState) {
              CategoryInitial() || CategoryLoading() => const Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                ),
              CategoryLoaded(:final categories) => ListView.separated(
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = selectedCategory?.id == category.id;
                    return _CategoryRow(
                      category: category,
                      isSelected: isSelected,
                      onTap: () => onCategorySelected(category),
                      onToggle: (value) {
                        ref.read(categoryControllerProvider.notifier).toggleCategoryActive(
                              id: category.id,
                              isActive: value,
                            );
                      },
                      onEdit: () => _showEditDialog(context, ref, category),
                    );
                  },
                ),
              CategoryError(:final message) => Center(
                  child: Text(
                    message,
                    style: const TextStyle(color: AppColors.cancelRed),
                  ),
                ),
            },
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => CategoryFormDialog(
        onSave: onCategoriesChanged,
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, CategoryEntity category) {
    showDialog(
      context: context,
      builder: (_) => CategoryFormDialog(
        category: category,
        onSave: onCategoriesChanged,
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final CategoryEntity category;
  final bool isSelected;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;

  const _CategoryRow({
    required this.category,
    required this.isSelected,
    required this.onTap,
    required this.onToggle,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onEdit,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: AppColors.accent, width: 2)
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                category.name,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  decoration: category.isActive ? null : TextDecoration.lineThrough,
                ),
              ),
            ),
            Opacity(
              opacity: category.isActive ? 1.0 : 0.5,
              child: Switch(
                value: category.isActive,
                onChanged: onToggle,
                activeThumbColor: AppColors.accent,
                activeTrackColor: AppColors.accent,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: AppColors.bgInput,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
