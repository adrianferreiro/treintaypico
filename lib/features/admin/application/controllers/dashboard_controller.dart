import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/features/admin/application/states/dashboard_state.dart';
import 'package:treintaypico/features/admin/data/datasources/firestore_dashboard_datasource.dart';
import 'package:treintaypico/features/events/data/datasources/event_datasource_provider.dart';
import 'package:treintaypico/features/events/data/mappers/event_mapper.dart';
import 'package:treintaypico/features/events/domain/entities/event_entity.dart';

class DashboardController extends StateNotifier<DashboardState> {
  final FirestoreDashboardDatasource _dashboardDatasource;
  final Ref _ref;
  bool _hasLoadedFromServer = false;

  DashboardController(this._dashboardDatasource, this._ref) : super(DashboardInitial());

  /// Loads dashboard only if not already loaded. Use [forceRefresh] to reload.
  Future<void> loadDashboard({required String companyId, bool forceRefresh = false}) async {
    // Skip if already loaded and not forcing refresh (saves Firebase reads)
    if (state is DashboardLoaded && !forceRefresh) return;

    final source = (_hasLoadedFromServer && !forceRefresh) ? Source.cache : Source.server;

    state = DashboardLoading();
    try {
      // Single query: get events by company
      final eventDatasource = _ref.read(eventDatasourceProvider);
      final events = await eventDatasource.getEventsByCompany(companyId, source: source);
      final activeEventModel = events.where((e) => e.isAvailable).firstOrNull;

      EventEntity? activeEvent;
      if (activeEventModel != null) {
        activeEvent = activeEventModel.toEntity();
      }

      // Only query orders if there's an active event
      if (activeEvent != null) {
        final stats = await _dashboardDatasource.getOrderStats(activeEvent.id, source: source);
        state = DashboardLoaded(
          activeEvent: activeEvent,
          totalSold: stats.totalSold,
          processedOrders: stats.processedOrders,
          pendingOrders: stats.pendingOrders,
        );
      } else {
        state = DashboardLoaded(
          activeEvent: null,
          totalSold: 0,
          processedOrders: 0,
          pendingOrders: 0,
        );
      }

      if (source == Source.server) {
        _hasLoadedFromServer = true;
      }
    } catch (e) {
      state = DashboardError('Error al cargar dashboard: $e');
    }
  }
}
