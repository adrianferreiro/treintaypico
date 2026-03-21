import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/styles/app_colors.dart';
import 'package:treintaypico/features/admin/presentation/widgets/category_form_dialog.dart';
import 'package:treintaypico/features/admin/presentation/widgets/category_list_panel.dart';
import 'package:treintaypico/features/admin/presentation/widgets/product_grid.dart';
import 'package:treintaypico/features/auth/application/providers/auth_providers.dart';
import 'package:treintaypico/features/auth/application/states/auth_state.dart';
import 'package:treintaypico/features/categories/application/providers/category_providers.dart';
import 'package:treintaypico/features/categories/application/states/category_state.dart';
import 'package:treintaypico/features/categories/domain/entities/category_entity.dart';

class ProductosScreen extends ConsumerStatefulWidget {
  final bool isPortrait;

  const ProductosScreen({super.key, this.isPortrait = false});

  @override
  ConsumerState<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends ConsumerState<ProductosScreen> {
  CategoryEntity? _selectedCategory;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategories();
    });
  }

  void _loadCategories() {
    final authState = ref.read(authControllerProvider);
    if (authState is AuthAuthenticated) {
      ref.read(categoryControllerProvider.notifier).loadCategories(
            authState.user.venueId ?? '',
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryControllerProvider);

    // Auto-select first category when loaded
    if (categoryState is CategoryLoaded && _selectedCategory == null && categoryState.categories.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedCategory = categoryState.categories.first;
        });
      });
    }

    if (widget.isPortrait) {
      return _buildPortraitLayout(categoryState);
    }

    return _buildLandscapeLayout(categoryState);
  }

  Widget _buildLandscapeLayout(CategoryState categoryState) {
    return Row(
      children: [
        CategoryListPanel(
          categoryState: categoryState,
          selectedCategory: _selectedCategory,
          onCategorySelected: (category) {
            setState(() {
              _selectedCategory = category;
            });
          },
          onCategoriesChanged: _loadCategories,
        ),
        Expanded(
          child: Container(
            color: AppColors.darkBackground,
            child: _selectedCategory != null
                ? ProductGrid(
                    key: ValueKey(_selectedCategory!.id),
                    category: _selectedCategory!,
                  )
                : const Center(
                    child: Text(
                      'Selecciona una categoría',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitLayout(CategoryState categoryState) {
    return Container(
      color: AppColors.darkBackground,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              const Text(
                'Productos',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => CategoryFormDialog(onSave: _loadCategories),
                  );
                },
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
          const SizedBox(height: 12),

          // Category Tabs
          _buildCategoryTabs(categoryState),
          const SizedBox(height: 12),

          // Product Grid
          Expanded(
            child: _selectedCategory != null
                ? ProductGrid(
                    key: ValueKey(_selectedCategory!.id),
                    category: _selectedCategory!,
                    isPortrait: true,
                  )
                : const Center(
                    child: Text(
                      'Selecciona una categoría',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(CategoryState categoryState) {
    return SizedBox(
      height: 40,
      child: switch (categoryState) {
        CategoryInitial() || CategoryLoading() => const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: AppColors.accent, strokeWidth: 2),
            ),
          ),
        CategoryLoaded(:final categories) => ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = _selectedCategory?.id == category.id;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.accent : AppColors.cardDark,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    category.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        CategoryError(:final message) => Center(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.cancelRed, fontSize: 12),
            ),
          ),
      },
    );
  }
}
