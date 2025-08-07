class OrderItemEntity {
  final String productId;
  final String productName;
  final int quantity;
  final int unitPrice;
  final int subtotal;

  const OrderItemEntity({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });
}
