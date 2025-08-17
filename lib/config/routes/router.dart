import 'package:go_router/go_router.dart';
import 'package:treintaypico/features/orders/presentation/screens/order_screen.dart';
import 'package:treintaypico/features/printing/presentation/screens/printing_screen.dart';

class AppRouter {
  static final GoRouter _routes = GoRouter(
    initialLocation: OrderScreen.path,
    routes: [
      GoRoute(
        path: OrderScreen.path,
        name: OrderScreen.name,
        builder: (_, __) => const OrderScreen(),
        routes: [
          GoRoute(
            path: PrintingScreen.path,
            name: PrintingScreen.name,
            builder: (context, state) {
              return PrintingScreen();
            },
          ),
        ],
      ),
    ],
  );

  /// Router Getter
  static GoRouter get routes => _routes;
}
