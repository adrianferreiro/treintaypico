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
      resizeToAvoidBottomInset:
          true, // asegura que el body se reduzca con el teclado
      appBar: AppBar(title: const Text('Detalle del Pedido')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                // agrega espacio inferior igual al teclado para evitar solapamiento
                bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            textInputAction: TextInputAction.search,
                            onSubmitted: (_) {
                              FocusScope.of(
                                context,
                              ).unfocus(); // opcional: cerrar teclado
                              controller.fetchOrderById(_idController.text);
                            },
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
                            controller.fetchOrderById(
                              _idController.text.trim(),
                            );
                          },
                          child: const Text('Buscar'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // navegación al escáner
                        },
                        icon: const Icon(Icons.qr_code_scanner),
                        label: const Text('Escanear QR'),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // CONTENIDO segun estado (sin Expanded adentro)
                    switch (state) {
                      OrderInitial() => const Center(
                        child: Text('Esperando ID o escaneo de código QR...'),
                      ),
                      OrderLoading() => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      OrderError(:final message) => Center(
                        child: Text(message),
                      ),
                      OrderLoaded(:final order) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize
                            .min, // 👈 importante para no pedir altura infinita
                        children: [
                          OrderDetail(order: order), // sin Expanded
                          const SizedBox(height: 12),
                          OrderActions(
                            onCancel: () => controller.cancelOrder(order.id),
                            onMarkAsPaid: () => controller.markAsPaid(
                              orderId: order.id,
                              paymentMethod: 'cash',
                            ),
                          ),
                        ],
                      ),
                    },
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
