import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/features/events/application/states/event_state.dart';
import 'package:treintaypico/features/events/application/usecases/create_event_usecase.dart';
import 'package:treintaypico/features/events/application/usecases/get_events_usecase.dart';
import 'package:treintaypico/features/events/application/usecases/toggle_event_usecase.dart';
import 'package:treintaypico/features/events/application/usecases/update_event_categories_usecase.dart';
import 'package:treintaypico/features/events/application/usecases/update_product_override_usecase.dart';

class EventController extends StateNotifier<EventState> {
  final GetEventsUseCase getEventsUseCase;
  final CreateEventUseCase createEventUseCase;
  final ToggleEventUseCase toggleEventUseCase;
  final UpdateProductOverrideUseCase updateProductOverrideUseCase;
  final UpdateEventCategoriesUseCase updateEventCategoriesUseCase;

  String? _currentCompanyId;

  EventController({
    required this.getEventsUseCase,
    required this.createEventUseCase,
    required this.toggleEventUseCase,
    required this.updateProductOverrideUseCase,
    required this.updateEventCategoriesUseCase,
  }) : super(EventInitial());

  Future<void> loadEvents(String companyId) async {
    _currentCompanyId = companyId;
    state = EventLoading();
    final result = await getEventsUseCase(
      GetEventsParams(companyId: companyId),
    );
    state = result.fold(
      (failure) => EventError(failure.message),
      (events) => EventLoaded(events),
    );
  }

  Future<void> toggleEventAvailable({
    required String id,
    required bool isAvailable,
  }) async {
    final result = await toggleEventUseCase(
      ToggleEventParams(id: id, isAvailable: isAvailable),
    );
    result.fold(
      (failure) => state = EventError(failure.message),
      (_) {
        if (_currentCompanyId != null) loadEvents(_currentCompanyId!);
      },
    );
  }

  Future<void> createEvent({
    required String name,
    required DateTime date,
    required String companyId,
    required String venueId,
    required String frontpage,
    required String logo,
    required List<String> categories,
  }) async {
    final result = await createEventUseCase(
      CreateEventParams(
        name: name,
        date: date,
        companyId: companyId,
        venueId: venueId,
        frontpage: frontpage,
        logo: logo,
        categories: categories,
      ),
    );
    result.fold(
      (failure) => state = EventError(failure.message),
      (_) {
        if (_currentCompanyId != null) loadEvents(_currentCompanyId!);
      },
    );
  }

  Future<void> updateEventCategories({
    required String eventId,
    required List<String> categories,
  }) async {
    final result = await updateEventCategoriesUseCase(
      UpdateEventCategoriesParams(
        eventId: eventId,
        categories: categories,
      ),
    );
    result.fold(
      (failure) => state = EventError(failure.message),
      (_) {
        if (_currentCompanyId != null) loadEvents(_currentCompanyId!);
      },
    );
  }

  Future<void> updateProductOverride({
    required String eventId,
    required String productId,
    required int price,
    required bool enabled,
  }) async {
    final result = await updateProductOverrideUseCase(
      UpdateProductOverrideParams(
        eventId: eventId,
        productId: productId,
        price: price,
        enabled: enabled,
      ),
    );
    result.fold(
      (failure) => state = EventError(failure.message),
      (_) {
        if (_currentCompanyId != null) loadEvents(_currentCompanyId!);
      },
    );
  }
}
