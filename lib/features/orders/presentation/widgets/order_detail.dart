import 'package:flutter/material.dart';
import 'package:treintaypico/core/styles/app_colors.dart';
import 'package:treintaypico/features/orders/domain/entities/order_entity.dart';

/// Order info card: header with order number, client name, and status badge.
/// Items list, total, and actions are handled by OrderScreen.
class OrderDetail extends StatelessWidget {
  final OrderEntity order;

  const OrderDetail({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: order number + client
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pedido #${order.orderNumber}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Cliente: ${order.userName}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          // Right: status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: _getBadgeColor(order.status),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              order.status.name.toUpperCase(),
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getBadgeColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.badgePending;
      case OrderStatus.paid:
        return AppColors.badgePaid;
      case OrderStatus.cancelled:
        return AppColors.cancelRed;
      default:
        return AppColors.grey;
    }
  }
}
