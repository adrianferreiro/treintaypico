class ProductEntity {
  final String id;
  final String name;
  final int price;
  final String categoryId;
  final bool isActive;
  final String? imageUrl;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    required this.isActive,
    this.imageUrl,
  });
}
