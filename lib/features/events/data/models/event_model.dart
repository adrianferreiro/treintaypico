class ProductOverrideModel {
  final int price;
  final bool enabled;

  const ProductOverrideModel({
    required this.price,
    required this.enabled,
  });

  factory ProductOverrideModel.fromJson(Map<String, dynamic> json) {
    return ProductOverrideModel(
      price: (json['price'] ?? 0).toInt(),
      enabled: json['enabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'enabled': enabled,
    };
  }
}

class EventModel {
  final String id;
  final String name;
  final DateTime date;
  final String venueId;
  final String? venueName;
  final String companyId;
  final bool isAvailable;
  final Map<String, ProductOverrideModel> productOverrides;
  final String frontpage;
  final String logo;
  final List<String> categories;

  const EventModel({
    required this.id,
    required this.name,
    required this.date,
    required this.venueId,
    this.venueName,
    required this.companyId,
    required this.isAvailable,
    required this.productOverrides,
    required this.frontpage,
    required this.logo,
    required this.categories,
  });

  factory EventModel.fromJson(String id, Map<String, dynamic> json) {
    final overridesData = json['productOverrides'];
    final overrides = <String, ProductOverrideModel>{};
    if (overridesData is Map) {
      for (final entry in overridesData.entries) {
        if (entry.value is Map) {
          overrides[entry.key.toString()] = ProductOverrideModel.fromJson(
            Map<String, dynamic>.from(entry.value as Map),
          );
        }
      }
    }

    final categoriesData = json['categories'];
    final categories = <String>[];
    if (categoriesData is List) {
      for (final item in categoriesData) {
        categories.add(item.toString());
      }
    }

    return EventModel(
      id: id,
      name: json['name'] ?? '',
      date: _parseDate(json['date']),
      venueId: json['venueId'] ?? '',
      venueName: json['venueName'],
      companyId: json['companyId'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
      productOverrides: overrides,
      frontpage: json['frontpage'] ?? '',
      logo: json['logo'] ?? '',
      categories: categories,
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    // Handle Firestore Timestamp
    if (value is Map && value['_seconds'] != null) {
      return DateTime.fromMillisecondsSinceEpoch(
        (value['_seconds'] as int) * 1000,
      );
    }
    return DateTime.now();
  }
}
