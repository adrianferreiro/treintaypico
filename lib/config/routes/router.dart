import 'package:go_router/go_router.dart';
import 'package:treintaypico/features/orders/presentation/screens/order_screen.dart';

class AppRouter {
  static final GoRouter _routes = GoRouter(
    initialLocation: OrderScreen.path,
    routes: [
      GoRoute(
        path: OrderScreen.path,
        name: OrderScreen.name,
        builder: (_, __) => const OrderScreen(),
        routes: [
          // GoRoute(
          //   path: ChallengeScreen.path,
          //   name: ChallengeScreen.name,
          //   builder: (context, state) {
          //     final params = state.extra as ChallengeParams;
          //     return ChallengeScreen(params: params);
          //   },
          // ),
        ],
      ),
    ],
  );

  /// Router Getter
  static GoRouter get routes => _routes;
}
