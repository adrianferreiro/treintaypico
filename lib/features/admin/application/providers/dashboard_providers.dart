import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/features/admin/application/controllers/dashboard_controller.dart';
import 'package:treintaypico/features/admin/application/states/dashboard_state.dart';
import 'package:treintaypico/features/admin/data/datasources/firestore_dashboard_datasource.dart';

final dashboardDatasourceProvider = Provider<FirestoreDashboardDatasource>((ref) {
  return FirestoreDashboardDatasource();
});

final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, DashboardState>((ref) {
  return DashboardController(
    ref.read(dashboardDatasourceProvider),
    ref,
  );
});
