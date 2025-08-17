import 'package:flutter/material.dart';
import 'package:treintaypico/features/ble_printing_temp/ble_print_temp.dart';
import 'package:treintaypico/features/orders/domain/entities/order_entity.dart';

class OrderActions extends StatelessWidget {
  final VoidCallback onCancel;
  final Future<void> Function()?
  onMarkAsPaidLogic; // si querés ejecutar tu lógica real (api/estado)
  final OrderEntity? order; // lo usamos para generar el ticket temporal
  final String? thermerPackage; // ej: "com.thermer.print" (cuando lo confirmes)

  const OrderActions({
    super.key,
    required this.onCancel,
    this.onMarkAsPaidLogic,
    this.order,
    this.thermerPackage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onCancel,
            icon: const Icon(Icons.cancel),
            label: const Text('Cancelar pedido'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              try {
                // 1) Ejecutá tu lógica de "marcar pagado" si te la pasan
                if (onMarkAsPaidLogic != null) {
                  await onMarkAsPaidLogic!();
                }

                // 2) Si tenemos el OrderEntity, generamos imagen y abrimos Thermer
                if (order != null) {
                  final png = await BlePrintTemp.buildOrderPng(order!);

                  // Si ya sabés el package exacto de Thermer, pasalo aquí:
                  // p.ej.: thermerPackage: "com.thermer.print"
                  await BlePrintTemp.openExternalPrinter(
                    pngBytes: png,
                    packageName: thermerPackage, // o dejalo null para chooser
                    fileName: 'ticket_${order!.orderNumber}.png',
                  );
                }

                // 3) Feedback
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pedido pagado e impresión abierta ✅'),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al imprimir: $e')),
                  );
                }
              }
            },
            icon: const Icon(Icons.check_circle),
            label: const Text('Pedido pagado'),
          ),
        ),
      ],
    );
  }
}
