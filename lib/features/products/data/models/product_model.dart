class ProductModel {
  final String id;
  final String name;
  final int price;
  final String categoryId;
  final bool isActive;
  final String? imageUrl;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    required this.isActive,
    this.imageUrl,
  });

  factory ProductModel.fromJson(String id, Map<String, dynamic> json) {
    return ProductModel(
      id: id,
      name: (json['name'] ?? '').toString(),
      price: ((json['price'] ?? 0) as num).toInt(),
      categoryId: (json['categoryId'] ?? '').toString(),
      isActive: json['isActive'] as bool? ?? true,
      imageUrl: json['imageUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'categoryId': categoryId,
      'isActive': isActive,
      'imageUrl': imageUrl,
    };
  }
}
