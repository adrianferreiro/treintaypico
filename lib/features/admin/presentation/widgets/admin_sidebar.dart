import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:treintaypico/core/styles/app_colors.dart';
import 'package:treintaypico/features/auth/application/providers/auth_providers.dart';

class AdminSidebar extends ConsumerWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final bool isCollapsed;

  const AdminSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.isCollapsed = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = isCollapsed ? 60.0 : 220.0;

    return Container(
      width: width,
      color: AppColors.darkBackground,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          // Logo Area
          Padding(
            padding: EdgeInsets.fromLTRB(isCollapsed ? 0 : 20, 0, isCollapsed ? 0 : 20, 24),
            child: isCollapsed
                ? Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.monitor,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  )
                : Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.monitor,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'EVNTS POS',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
          ),

          // Nav Items
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 8 : 8),
              child: Column(
                children: [
                  _NavItem(
                    icon: Icons.dashboard_outlined,
                    label: 'Dashboard',
                    isSelected: selectedIndex == 0,
                    isCollapsed: isCollapsed,
                    onTap: () => onItemSelected(0),
                  ),
                  const SizedBox(height: 2),
                  _NavItem(
                    icon: Icons.inventory_2_outlined,
                    label: 'Productos',
                    isSelected: selectedIndex == 1,
                    isCollapsed: isCollapsed,
                    onTap: () => onItemSelected(1),
                  ),
                  const SizedBox(height: 2),
                  _NavItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'Eventos',
                    isSelected: selectedIndex == 2,
                    isCollapsed: isCollapsed,
                    onTap: () => onItemSelected(2),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Nav
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 8 : 8),
            child: Column(
              children: [
                const Divider(color: AppColors.border, height: 1),
                const SizedBox(height: 8),
                _NavItem(
                  icon: Icons.logout,
                  label: 'Cerrar Sesión',
                  isSelected: false,
                  isLogout: true,
                  isCollapsed: isCollapsed,
                  onTap: () {
                    ref.read(authControllerProvider.notifier).logout();
                    context.go('/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isLogout;
  final bool isCollapsed;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isLogout = false,
    this.isCollapsed = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isLogout
        ? AppColors.cancelRed
        : isSelected
            ? Colors.white
            : AppColors.textSecondary;

    if (isCollapsed) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.accent : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(icon, color: color, size: 20),
            ),
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
