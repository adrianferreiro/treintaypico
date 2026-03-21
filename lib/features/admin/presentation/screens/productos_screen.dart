import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/styles/app_colors.dart';
import 'package:treintaypico/features/admin/presentation/widgets/category_list_panel.dart';
import 'package:treintaypico/features/admin/presentation/widgets/product_grid.dart';
import 'package:treintaypico/features/auth/application/providers/auth_providers.dart';
import 'package:treintaypico/features/auth/application/states/auth_state.dart';
import 'package:treintaypico/features/categories/application/providers/category_providers.dart';
import 'package:treintaypico/features/categories/application/states/category_state.dart';
import 'package:treintaypico/features/categories/domain/entities/category_entity.dart';

class ProductosScreen extends ConsumerStatefulWidget {
  const ProductosScreen({super.key});

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

    return Row(
      children: [
        // Categories Panel (left)
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

        // Products Panel (right)
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
}
