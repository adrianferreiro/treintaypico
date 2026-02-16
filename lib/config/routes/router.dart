import 'package:go_router/go_router.dart';
import 'package:treintaypico/features/auth/presentation/screens/login_screen.dart';
import 'package:treintaypico/features/orders/presentation/screens/order_screen.dart';

class AppRouter {
  static final GoRouter _routes = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: OrderScreen.path,
        name: OrderScreen.name,
        builder: (_, __) => const OrderScreen(),
      ),
    ],
  );

  /// Router Getter
  static GoRouter get routes => _routes;
}
