import 'package:treintaypico/features/events/domain/entities/event_entity.dart';

sealed class EventState {}

final class EventInitial extends EventState {}

final class EventLoading extends EventState {}

final class EventLoaded extends EventState {
  final List<EventEntity> events;
  EventLoaded(this.events);
}

final class EventError extends EventState {
  final String message;
  EventError(this.message);
}
