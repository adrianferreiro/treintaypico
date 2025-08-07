import 'package:flutter/material.dart';
import 'package:treintaypico/features/orders/domain/entities/order_entity.dart';

class OrderDetail extends StatelessWidget {
  final OrderEntity order;

  const OrderDetail({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(30),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pedido: ${order.orderNumber}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text('Estado: ${order.status.name}'),
          Text('Total: \$${order.totalAmount}'),
          const SizedBox(height: 12),

          const Text(
            'Productos:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: order.items.length,
              itemBuilder: (_, index) {
                final item = order.items[index];
                return ListTile(
                  title: Text(item.productName),
                  subtitle: Text('${item.quantity} x \$${item.unitPrice}'),
                  trailing: Text('\$${item.subtotal}'),
                );
              },
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
