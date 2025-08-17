import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:treintaypico/features/ble_printing_temp/ble_print_temp.dart';

import 'package:treintaypico/features/orders/application/providers/order_providers.dart';
import 'package:treintaypico/features/orders/application/states/order_state.dart';
import 'package:treintaypico/features/orders/domain/entities/order_entity.dart';
import 'package:treintaypico/features/orders/presentation/widgets/order_action.dart';
import 'package:treintaypico/features/orders/presentation/widgets/order_detail.dart';

// Si ya sabés el package exacto de Thermer en tu dispositivo, ponelo acá.
// Si no, dejalo en null y abrirá el chooser.
const String? kThermerPackage = null; // ej: 'com.thermer.print'

class OrderScreen extends ConsumerStatefulWidget {
  static const name = 'order-screen';
  static const path = '/order';
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  final TextEditingController _idController = TextEditingController();

  Future<void> _handleMarkAsPaid(OrderEntity order) async {
    final controller = ref.read(orderControllerProvider.notifier);
    try {
      // 1) Lógica real de marcar pagado
      await controller.markAsPaid(orderId: order.id, paymentMethod: 'cash');

      // 2) Generar ticket PNG y abrir Thermer (o chooser si kThermerPackage == null)
      final png = await BlePrintTemp.buildOrderPng(order);
      await BlePrintTemp.openExternalPrinter(
        pngBytes: png,
        packageName: kThermerPackage,
        fileName: 'ticket_${order.orderNumber}.png',
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido pagado e impresión abierta ✅')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al marcar pagado/imprimir: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderControllerProvider);
    final controller = ref.read(orderControllerProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                              FocusScope.of(context).unfocus();
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
                          // navegación al escáner (pendiente)
                        },
                        icon: const Icon(Icons.qr_code_scanner),
                        label: const Text('Escanear QR'),
                      ),
                    ),
                    const SizedBox(height: 16),

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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OrderDetail(order: order),
                          const SizedBox(height: 12),
                          // ✅ usar onMarkAsPaidLogic + order + thermerPackage
                          OrderActions(
                            onCancel: () => controller.cancelOrder(order.id),
                            onMarkAsPaidLogic: () => _handleMarkAsPaid(order),
                            order: order,
                            thermerPackage: kThermerPackage,
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
