class CategoryModel {
  final String id;
  final String name;
  final String venueId;
  final int order;
  final bool isActive;
  final String? imageUrl;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.venueId,
    required this.order,
    required this.isActive,
    this.imageUrl,
  });

  factory CategoryModel.fromJson(String id, Map<String, dynamic> json) {
    return CategoryModel(
      id: id,
      name: (json['name'] ?? '').toString(),
      venueId: (json['venueId'] ?? '').toString(),
      order: ((json['order'] ?? 0) as num).toInt(),
      isActive: json['isActive'] as bool? ?? true,
      imageUrl: json['imageUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'venueId': venueId,
      'order': order,
      'isActive': isActive,
      'imageUrl': imageUrl,
    };
  }
}
