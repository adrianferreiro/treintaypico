class ProductOverride {
  final int price;
  final bool enabled;

  const ProductOverride({
    required this.price,
    required this.enabled,
  });
}

class EventEntity {
  final String id;
  final String name;
  final DateTime date;
  final String venueId;
  final String? venueName;
  final String companyId;
  final bool isAvailable;
  final Map<String, ProductOverride> productOverrides;
  final String frontpage;
  final String logo;
  final List<String> categories;

  const EventEntity({
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
}
