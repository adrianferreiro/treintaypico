import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/features/orders/application/providers/order_providers.dart';
import 'package:treintaypico/features/orders/application/states/order_state.dart';
import 'package:treintaypico/features/orders/presentation/widgets/order_action.dart';
import 'package:treintaypico/features/orders/presentation/widgets/order_detail.dart';

class OrderScreen extends ConsumerStatefulWidget {
  static const name = 'order-screen';
  static const path = '/order';
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  final TextEditingController _idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderControllerProvider);
    final controller = ref.read(orderControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Pedido')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Input de ID + botón buscar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      labelText: 'ID del pedido',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    controller.fetchOrderById(_idController.text.trim());
                  },
                  child: const Text('Buscar'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Botón escanear QR
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // pendiente: navegación al escáner
                },
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Escanear QR'),
              ),
            ),
            const SizedBox(height: 16),

            // Estado del pedido
            Expanded(
              child: switch (state) {
                OrderInitial() => const Center(
                  child: Text('Esperando ID o escaneo de código QR...'),
                ),
                OrderLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                OrderError(:final message) => Center(child: Text(message)),
                OrderLoaded(:final order) => Column(
                  children: [
                    // Detalle visual del pedido
                    Expanded(child: OrderDetail(order: order)),
                    const SizedBox(height: 12),

                    // Botones de acción
                    OrderActions(
                      onCancel: () {
                        controller.cancelOrder(order.id);
                      },
                      onMarkAsPaid: () {
                        // Podés reemplazar 'cash' por otro método si usás un selector.
                        controller.markAsPaid(
                          orderId: order.id,
                          paymentMethod: 'cash',
                        );
                      },
                    ),
                  ],
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
