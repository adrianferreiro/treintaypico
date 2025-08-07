import 'package:flutter/material.dart';

class OrderActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onMarkAsPaid;

  const OrderActions({
    super.key,
    required this.onCancel,
    required this.onMarkAsPaid,
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
            onPressed: onMarkAsPaid,
            icon: const Icon(Icons.check_circle),
            label: const Text('Pedido pagado'),
          ),
        ),
      ],
    );
  }
}
