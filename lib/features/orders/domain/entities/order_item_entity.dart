class OrderItemEntity {
  final String categoryId; // 🔹 nuevo campo
  final String productName;
  final int quantity;
  final int unitPrice;
  final int subtotal;

  const OrderItemEntity({
    required this.categoryId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });
}
