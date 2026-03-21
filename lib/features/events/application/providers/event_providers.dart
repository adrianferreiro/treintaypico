import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/features/events/application/controllers/event_controller.dart';
import 'package:treintaypico/features/events/application/states/event_state.dart';
import 'package:treintaypico/features/events/application/usecases/create_event_usecase.dart';
import 'package:treintaypico/features/events/application/usecases/get_events_usecase.dart';
import 'package:treintaypico/features/events/application/usecases/toggle_event_usecase.dart';
import 'package:treintaypico/features/events/application/usecases/update_event_categories_usecase.dart';
import 'package:treintaypico/features/events/application/usecases/update_product_override_usecase.dart';
import 'package:treintaypico/features/events/data/datasources/event_datasource_provider.dart';
import 'package:treintaypico/features/events/data/repositories/event_repository_impl.dart';
import 'package:treintaypico/features/events/domain/repositories/event_repository.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final datasource = ref.read(eventDatasourceProvider);
  return EventRepositoryImpl(datasource: datasource);
});

final createEventUseCaseProvider = Provider<CreateEventUseCase>((ref) {
  final repo = ref.read(eventRepositoryProvider);
  return CreateEventUseCase(repository: repo);
});

final updateEventCategoriesUseCaseProvider = Provider<UpdateEventCategoriesUseCase>((ref) {
  final repo = ref.read(eventRepositoryProvider);
  return UpdateEventCategoriesUseCase(repository: repo);
});

final eventControllerProvider =
    StateNotifierProvider<EventController, EventState>((ref) {
  return EventController(
    getEventsUseCase: ref.read(getEventsUseCaseProvider),
    createEventUseCase: ref.read(createEventUseCaseProvider),
    toggleEventUseCase: ref.read(toggleEventUseCaseProvider),
    updateProductOverrideUseCase: ref.read(updateProductOverrideUseCaseProvider),
    updateEventCategoriesUseCase: ref.read(updateEventCategoriesUseCaseProvider),
  );
});
