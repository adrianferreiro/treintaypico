import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/features/orders/application/controllers/order_controller.dart';
import 'package:treintaypico/features/orders/application/states/order_state.dart';
import 'package:treintaypico/features/orders/application/usecases/cancel_order_usecase.dart';
import 'package:treintaypico/features/orders/application/usecases/get_order_by_id_usecase.dart';
import 'package:treintaypico/features/orders/application/usecases/mark_order_as_paid_usecase.dart';
import 'package:treintaypico/features/orders/data/datasources/order_datasource_provider.dart';
import 'package:treintaypico/features/orders/data/repositories/order_repository_impl.dart';
import 'package:treintaypico/features/orders/domain/repositories/order_repository.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final datasource = ref.read(orderDatasourceProvider);
  return OrderRepositoryImpl(datasource: datasource);
});

final orderControllerProvider =
    StateNotifierProvider<OrderController, OrderState>((ref) {
      return OrderController(
        getOrderByIdUseCase: ref.read(getOrderByIdUseCaseProvider),
        cancelOrderUseCase: ref.read(cancelOrderUseCaseProvider),
        markOrderAsPaidUseCase: ref.read(markOrderAsPaidUseCaseProvider),
      );
    });
