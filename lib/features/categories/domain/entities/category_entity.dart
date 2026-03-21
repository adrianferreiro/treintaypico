class CategoryEntity {
  final String id;
  final String name;
  final String venueId;
  final int order;
  final bool isActive;
  final String? imageUrl;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.venueId,
    required this.order,
    required this.isActive,
    this.imageUrl,
  });
}
