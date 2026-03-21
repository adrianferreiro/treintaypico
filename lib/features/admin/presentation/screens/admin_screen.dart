import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/styles/app_colors.dart';
import 'package:treintaypico/features/admin/presentation/screens/dashboard_screen.dart';
import 'package:treintaypico/features/admin/presentation/screens/eventos_screen.dart';
import 'package:treintaypico/features/admin/presentation/screens/productos_screen.dart';
import 'package:treintaypico/features/admin/presentation/widgets/admin_sidebar.dart';

class AdminScreen extends ConsumerStatefulWidget {
  static const String path = '/admin';
  static const String name = 'admin';

  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isPortrait = constraints.maxWidth < 900;

          return Row(
            children: [
              AdminSidebar(
                selectedIndex: _selectedIndex,
                isCollapsed: isPortrait,
                onItemSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    DashboardScreen(isPortrait: isPortrait),
                    ProductosScreen(isPortrait: isPortrait),
                    EventosScreen(isPortrait: isPortrait),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
