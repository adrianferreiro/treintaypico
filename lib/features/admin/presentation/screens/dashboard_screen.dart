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
  final bool isPortrait;

  const DashboardScreen({super.key, this.isPortrait = false});

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
      padding: EdgeInsets.all(widget.isPortrait ? 16 : 24),
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
              if (widget.isPortrait)
                _buildPortraitStats(totalSold, processedOrders, pendingOrders)
              else
                _buildLandscapeStats(totalSold, processedOrders, pendingOrders),
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

  Widget _buildLandscapeStats(int totalSold, int processedOrders, int pendingOrders) {
    return Row(
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
            label: 'Terminales Activas',
            value: '1',
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitStats(int totalSold, int processedOrders, int pendingOrders) {
    return Column(
      children: [
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
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                icon: Icons.shopping_cart_outlined,
                iconColor: AppColors.accentLight,
                label: 'Pedidos Procesados',
                value: processedOrders.toString(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.timer_outlined,
                iconColor: AppColors.badgePending,
                label: 'Pedidos Pendientes',
                value: pendingOrders.toString(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                icon: Icons.monitor,
                iconColor: AppColors.accent,
                label: 'Terminales Activas',
                value: '1',
              ),
            ),
          ],
        ),
      ],
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
