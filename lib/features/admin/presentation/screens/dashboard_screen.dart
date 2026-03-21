import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/styles/app_colors.dart';
import 'package:treintaypico/features/admin/application/providers/dashboard_providers.dart';
import 'package:treintaypico/features/admin/application/states/dashboard_state.dart';
import 'package:treintaypico/features/admin/presentation/widgets/event_header.dart';
import 'package:treintaypico/features/admin/presentation/widgets/stat_card.dart';
import 'package:treintaypico/features/auth/application/providers/auth_providers.dart';
import 'package:treintaypico/features/auth/application/states/auth_state.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboard();
    });
  }

  void _loadDashboard({bool forceRefresh = false}) {
    final authState = ref.read(authControllerProvider);
    if (authState is AuthAuthenticated) {
      ref.read(dashboardControllerProvider.notifier).loadDashboard(
            companyId: authState.user.companyId ?? '',
            forceRefresh: forceRefresh,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardControllerProvider);

    return Container(
      color: AppColors.darkBackground,
      padding: const EdgeInsets.all(24),
      child: switch (state) {
        DashboardInitial() => const Center(
            child: Text(
              'Cargando dashboard...',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        DashboardLoading() => const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          ),
        DashboardLoaded(:final activeEvent, :final totalSold, :final processedOrders, :final pendingOrders) =>
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: EventHeader(
                      eventName: activeEvent?.name ?? 'Sin evento activo',
                      eventDate: activeEvent?.date,
                      venueName: activeEvent?.venueName,
                      isLive: activeEvent != null,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _loadDashboard(forceRefresh: true),
                    icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
                    tooltip: 'Actualizar',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.attach_money,
                      iconColor: AppColors.badgePaid,
                      label: 'Total Vendido',
                      value: '\$${_formatNumber(totalSold)}',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      icon: Icons.shopping_cart_outlined,
                      iconColor: AppColors.accentLight,
                      label: 'Pedidos Procesados',
                      value: processedOrders.toString(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      icon: Icons.timer_outlined,
                      iconColor: AppColors.badgePending,
                      label: 'Pedidos Pendientes',
                      value: pendingOrders.toString(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      icon: Icons.monitor,
                      iconColor: AppColors.accent,
                      label: 'Cajas Activas',
                      value: '0',
                    ),
                  ),
                ],
              ),
            ],
          ),
        DashboardError(:final message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  message,
                  style: const TextStyle(color: AppColors.cancelRed),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadDashboard,
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
      },
    );
  }

  String _formatNumber(int number) {
    final str = number.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}
