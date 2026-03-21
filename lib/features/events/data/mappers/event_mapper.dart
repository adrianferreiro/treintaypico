import 'package:treintaypico/features/events/data/models/event_model.dart';
import 'package:treintaypico/features/events/domain/entities/event_entity.dart';

extension ProductOverrideMapper on ProductOverrideModel {
  ProductOverride toEntity() {
    return ProductOverride(
      price: price,
      enabled: enabled,
    );
  }
}

extension EventMapper on EventModel {
  EventEntity toEntity() {
    return EventEntity(
      id: id,
      name: name,
      date: date,
      venueId: venueId,
      venueName: venueName,
      companyId: companyId,
      isAvailable: isAvailable,
      productOverrides: productOverrides.map(
        (key, value) => MapEntry(key, value.toEntity()),
      ),
      frontpage: frontpage,
      logo: logo,
      categories: categories,
    );
  }
}

extension EventModelListMapper on List<EventModel> {
  List<EventEntity> toEntityList() => map((e) => e.toEntity()).toList();
}
