class OrderItemModel {
  final String categoryId;
  final String productName;
  final int quantity;
  final int unitPrice;
  final int subtotal;

  const OrderItemModel({
    required this.categoryId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      categoryId: json['category_id'] as String,
      productName: json['product_name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unit_price'] as num).toInt(),
      subtotal: (json['subtotal'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'product_name': productName,
      'quantity': quantity,
      'unit_price': unitPrice,
      'subtotal': subtotal,
    };
  }
}
