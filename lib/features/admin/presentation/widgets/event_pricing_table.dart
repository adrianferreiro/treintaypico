import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/styles/app_colors.dart';
import 'package:treintaypico/features/events/application/providers/event_providers.dart';
import 'package:treintaypico/features/events/domain/entities/event_entity.dart';
import 'package:treintaypico/features/products/application/providers/product_providers.dart';
import 'package:treintaypico/features/products/application/states/product_state.dart';
import 'package:treintaypico/features/products/domain/entities/product_entity.dart';
import 'package:treintaypico/features/categories/application/providers/category_providers.dart';
import 'package:treintaypico/features/categories/application/states/category_state.dart';

class EventPricingTable extends ConsumerStatefulWidget {
  final EventEntity event;
  final VoidCallback onOverrideUpdated;

  const EventPricingTable({
    super.key,
    required this.event,
    required this.onOverrideUpdated,
  });

  @override
  ConsumerState<EventPricingTable> createState() => _EventPricingTableState();
}

class _EventPricingTableState extends ConsumerState<EventPricingTable> {
  List<ProductEntity> _allProducts = [];
  bool _isLoadingProducts = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllProducts();
    });
  }

  @override
  void didUpdateWidget(covariant EventPricingTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.event.id != widget.event.id) {
      _loadAllProducts();
    }
  }

  Future<void> _loadAllProducts() async {
    setState(() => _isLoadingProducts = true);

    // Get categories first, then products for each category
    final categoryState = ref.read(categoryControllerProvider);
    if (categoryState is! CategoryLoaded) {
      setState(() => _isLoadingProducts = false);
      return;
    }

    final allProducts = <ProductEntity>[];
    for (final category in categoryState.categories) {
      await ref.read(productControllerProvider.notifier).loadProducts(category.id);
      final productState = ref.read(productControllerProvider);
      if (productState is ProductLoaded) {
        allProducts.addAll(productState.products);
      }
    }

    if (mounted) {
      setState(() {
        _allProducts = allProducts;
        _isLoadingProducts = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Precios del Evento',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // Table Header
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.bgSecondary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Text(
                    'Producto',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Text(
                    'Precio Base',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 140,
                  child: Text(
                    'Precio Evento',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'Habilitado',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Table Rows
          Expanded(
            child: _isLoadingProducts
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  )
                : _allProducts.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay productos disponibles',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _allProducts.length,
                        itemBuilder: (context, index) {
                          final product = _allProducts[index];
                          final override = widget.event.productOverrides[product.id];
                          return _PricingRow(
                            product: product,
                            eventPrice: override?.price ?? product.price,
                            isEnabled: override?.enabled ?? true,
                            onPriceChanged: (price) {
                              ref.read(eventControllerProvider.notifier).updateProductOverride(
                                    eventId: widget.event.id,
                                    productId: product.id,
                                    price: price,
                                    enabled: override?.enabled ?? true,
                                  );
                            },
                            onToggle: (enabled) {
                              ref.read(eventControllerProvider.notifier).updateProductOverride(
                                    eventId: widget.event.id,
                                    productId: product.id,
                                    price: override?.price ?? product.price,
                                    enabled: enabled,
                                  );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _PricingRow extends StatefulWidget {
  final ProductEntity product;
  final int eventPrice;
  final bool isEnabled;
  final ValueChanged<int> onPriceChanged;
  final ValueChanged<bool> onToggle;

  const _PricingRow({
    required this.product,
    required this.eventPrice,
    required this.isEnabled,
    required this.onPriceChanged,
    required this.onToggle,
  });

  @override
  State<_PricingRow> createState() => _PricingRowState();
}

class _PricingRowState extends State<_PricingRow> {
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(text: widget.eventPrice.toString());
  }

  @override
  void didUpdateWidget(covariant _PricingRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.eventPrice != widget.eventPrice) {
      _priceController.text = widget.eventPrice.toString();
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.product.name,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontFamily: 'Inter',
                fontSize: 13,
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              '\$${_formatPrice(widget.product.price)}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontFamily: 'Inter',
                fontSize: 13,
              ),
            ),
          ),
          SizedBox(
            width: 140,
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.bgInput,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: _priceController,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: 'Inter',
                  fontSize: 13,
                ),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  prefixText: '\$',
                  prefixStyle: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                  ),
                ),
                onSubmitted: (value) {
                  final price = int.tryParse(value);
                  if (price != null) {
                    widget.onPriceChanged(price);
                  }
                },
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Center(
              child: Switch(
                value: widget.isEnabled,
                onChanged: widget.onToggle,
                activeThumbColor: AppColors.badgePaid,
                activeTrackColor: AppColors.badgePaid,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: AppColors.bgInput,
              ),
            ),
          ),
        ],
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
