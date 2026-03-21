import 'package:treintaypico/features/events/domain/entities/event_entity.dart';

sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

final class DashboardLoading extends DashboardState {}

final class DashboardLoaded extends DashboardState {
  final EventEntity? activeEvent;
  final int totalSold;
  final int processedOrders;
  final int pendingOrders;

  DashboardLoaded({
    this.activeEvent,
    required this.totalSold,
    required this.processedOrders,
    required this.pendingOrders,
  });
}

final class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}
