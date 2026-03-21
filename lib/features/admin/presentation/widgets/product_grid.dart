import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/styles/app_colors.dart';
import 'package:treintaypico/features/admin/presentation/widgets/product_form_dialog.dart';
import 'package:treintaypico/features/categories/domain/entities/category_entity.dart';
import 'package:treintaypico/features/products/application/providers/product_providers.dart';
import 'package:treintaypico/features/products/application/states/product_state.dart';
import 'package:treintaypico/features/products/domain/entities/product_entity.dart';

class ProductGrid extends ConsumerStatefulWidget {
  final CategoryEntity category;
  final bool isPortrait;

  const ProductGrid({super.key, required this.category, this.isPortrait = false});

  @override
  ConsumerState<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends ConsumerState<ProductGrid> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProducts();
    });
  }

  @override
  void didUpdateWidget(covariant ProductGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category.id != widget.category.id) {
      _loadProducts();
    }
  }

  void _loadProducts() {
    ref.read(productControllerProvider.notifier).loadProducts(widget.category.id);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productControllerProvider);

    return Padding(
      padding: EdgeInsets.all(widget.isPortrait ? 0 : 20),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Text(
                widget.category.name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              if (!widget.isPortrait)
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.bgInput,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: AppColors.textMuted, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Buscar productos...',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontFamily: 'Inter',
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (widget.isPortrait) const Spacer(),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => _showCreateDialog(context),
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add, color: Colors.white, size: 16),
                      if (!widget.isPortrait) ...[
                        const SizedBox(width: 8),
                        const Text(
                          'Nuevo Producto',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Grid
          Expanded(
            child: switch (state) {
              ProductInitial() || ProductLoading() => const Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                ),
              ProductLoaded(:final products) => products.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay productos en esta categoría',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: widget.isPortrait ? 3 : 3,
                        crossAxisSpacing: widget.isPortrait ? 12 : 16,
                        mainAxisSpacing: widget.isPortrait ? 12 : 16,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return _ProductCard(
                          product: products[index],
                          onTap: () => _showEditDialog(context, products[index]),
                        );
                      },
                    ),
              ProductError(:final message) => Center(
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

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ProductFormDialog(
        categoryId: widget.category.id,
        onSave: _loadProducts,
      ),
    );
  }

  void _showEditDialog(BuildContext context, ProductEntity product) {
    showDialog(
      context: context,
      builder: (_) => ProductFormDialog(
        product: product,
        categoryId: widget.category.id,
        onSave: _loadProducts,
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onTap;

  const _ProductCard({
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Expanded(
              child: Container(
                width: double.infinity,
                color: product.imageUrl != null
                    ? AppColors.bgInput
                    : AppColors.cardBrown,
                child: product.imageUrl != null
                    ? Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.image, color: AppColors.textMuted, size: 40),
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.image, color: AppColors.textMuted, size: 40),
                      ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      decoration: product.isActive ? null : TextDecoration.lineThrough,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${_formatPrice(product.price)}',
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    final str = price.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}
