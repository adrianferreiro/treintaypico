import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/styles/app_colors.dart';
import 'package:treintaypico/features/orders/application/providers/order_providers.dart';
import 'package:treintaypico/features/orders/application/states/order_state.dart';
import 'package:treintaypico/features/orders/domain/entities/order_entity.dart';
import 'package:treintaypico/features/orders/presentation/widgets/order_detail.dart';
import 'package:go_router/go_router.dart';
import 'package:treintaypico/features/auth/application/providers/auth_providers.dart';
import 'package:treintaypico/features/orders/presentation/screens/qr_scanner_screen.dart';
import 'package:treintaypico/features/orders/data/services/ticket_printer_service.dart';

class OrderScreen extends ConsumerStatefulWidget {
  static const name = 'order-screen';
  static const path = '/order';
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  final TextEditingController _idController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  OrderEntity? _lastOrder;

  @override
  void dispose() {
    _idController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _showCancelDialog(BuildContext context, dynamic controller, String orderId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text(
          'Cancelar pedido',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          '¿Estás seguro que deseas cancelar el pedido?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('No', style: TextStyle(color: AppColors.textPrimary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              controller.cancelOrder(orderId);
            },
            child: const Text('Sí, cancelar', style: TextStyle(color: AppColors.cancelRed)),
          ),
        ],
      ),
    );
  }

  void _resetAndFocus() {
    _idController.clear();
    ref.read(orderControllerProvider.notifier).resetState();
    _searchFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderControllerProvider);
    final controller = ref.read(orderControllerProvider.notifier);

    // Auto-reset después de Success
    ref.listen<OrderState>(orderControllerProvider, (previous, next) async {
      if (next is OrderSuccess) {
        _idController.clear();
        //printer ticket 
        if (_lastOrder != null) {
          final printed = await TicketPrinterService().printTicket(_lastOrder!);
          if (!printed && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No se pudo imprimir el ticket')),
            );
          }
          _lastOrder = null;
      }
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            controller.resetState();
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Column(
        children: [
          // Top Section: AppBar + Search + Order Card
          _buildTopBar(context),
          _buildSearchBar(controller),

          // Content: changes based on state
          Expanded(
            child: switch (state) {
              OrderInitial() => _buildInitialState(),
              OrderLoading() => _buildLoadingState(),
              OrderError(:final message) => _buildErrorState(message),
              OrderSuccess(:final message) => _buildSuccessState(message),
              OrderLoaded(:final order) => _buildLoadedState(order, controller),
            },
          ),
        ],
      ),
    );
  }

  /// AppBar: "Detalle del Pedido" + logout icon
  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Detalle del Pedido',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textSecondary, size: 28),
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }

  /// Search bar with QR scanner icon
  Widget _buildSearchBar(dynamic controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.textSecondary, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _idController,
                focusNode: _searchFocusNode,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
                decoration: const InputDecoration(
                  hintText: 'ORD-TEST-001',
                  hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 16),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onSubmitted: (value) {
                  controller.fetchOrderById(value.trim());
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.qr_code_scanner, color: AppColors.textSecondary, size: 24),
              onPressed: () async {
                final result = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(builder: (_) => const QrScannerScreen()), 
                );
                if(result != null){
                  final scannedValue = result.trim();
                  _idController.text = scannedValue;
                  controller.fetchOrderById(scannedValue);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Estado inicial - esperando pedido
  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: AppColors.textMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Esperando pedido...',
            style: TextStyle(color: AppColors.textMuted, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Busca un pedido o escanea un código QR',
            style: TextStyle(
              color: AppColors.textMuted.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Estado loading
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.accent),
    );
  }

  /// Estado error
  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: AppColors.cancelRed),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: AppColors.cancelRed, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Estado success
  Widget _buildSuccessState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, size: 100, color: AppColors.badgePaid),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Estado loaded - order detail + actions
  Widget _buildLoadedState(OrderEntity order, dynamic controller) {
    return Column(
      children: [
        // Order info card
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
          child: OrderDetail(order: order),
        ),

        // Bottom section: items + total + actions
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
            child: Column(
              children: [
                // Items list
                Expanded(child: _buildItemsList(order)),
                const SizedBox(height: 20),

                // Total card
                _buildTotalCard(order),
                const SizedBox(height: 20),

                // Actions (paid/cancelled alert or pay/cancel buttons)
                if (order.isPaid || order.status == OrderStatus.cancelled)
                  _buildProcessedActions(order)
                else
                  _buildPendingActions(order, controller),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Lista de items del pedido
  Widget _buildItemsList(OrderEntity order) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: order.items.length,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
          color: AppColors.border,
        ),
        itemBuilder: (context, index) {
          final item = order.items[index];
          return Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                // Product icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.local_drink, color: AppColors.accent, size: 22),
                ),
                const SizedBox(width: 14),
                // Product info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '\$${item.unitPrice.toStringAsFixed(0)} x${item.quantity}',
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                // Price
                Text(
                  '\$${item.subtotal.toStringAsFixed(3)}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Card del total
  Widget _buildTotalCard(OrderEntity order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '\$${order.totalAmount.toStringAsFixed(3)}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${order.items.length} items',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Botones para pedido pendiente: Pagar + Cancelar
  Widget _buildPendingActions(OrderEntity order, dynamic controller) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 68,
            child: ElevatedButton(
              onPressed: () {
                _lastOrder = order;
                controller.markAsPaid(
                  orderId: order.id,
                  paymentMethod: 'cash',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Pagar',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SizedBox(
            height: 68,
            child: ElevatedButton(
              onPressed: () => _showCancelDialog(context, controller, order.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Alerta + botón para pedidos ya procesados (paid/cancelled)
  Widget _buildProcessedActions(OrderEntity order) {
    return Column(
      children: [
        // Warning banner
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.alertPaidBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.alertPaidBorder),
          ),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.alertPaidText, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  order.isPaid
                      ? 'Este pedido ya fue PAGADO.'
                      : 'Este pedido fue CANCELADO.',
                  style: const TextStyle(
                    color: AppColors.alertPaidText,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Buscar otro pedido
        SizedBox(
          width: double.infinity,
          height: 68,
          child: ElevatedButton(
            onPressed: _resetAndFocus,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Buscar otro pedido',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
