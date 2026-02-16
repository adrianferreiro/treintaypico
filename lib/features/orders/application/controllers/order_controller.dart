import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/features/orders/application/states/order_state.dart';
import 'package:treintaypico/features/orders/application/usecases/get_order_by_id_usecase.dart';
import 'package:treintaypico/features/orders/application/usecases/cancel_order_usecase.dart';
import 'package:treintaypico/features/orders/application/usecases/mark_order_as_paid_usecase.dart';

class OrderController extends StateNotifier<OrderState> {
  final GetOrderByIdUseCase getOrderByIdUseCase;
  final CancelOrderUseCase cancelOrderUseCase;
  final MarkOrderAsPaidUseCase markOrderAsPaidUseCase;

  OrderController({
    required this.getOrderByIdUseCase,
    required this.cancelOrderUseCase,
    required this.markOrderAsPaidUseCase,
  }) : super(OrderInitial());

  Future<void> fetchOrderById(String id) async {
    state = OrderLoading();
    final result = await getOrderByIdUseCase(OrderParams(orderId: id));
    state = result.fold(
      (failure) => OrderError(failure.message),
      (order) => OrderLoaded(order),
    );
  }

  Future<void> cancelOrder(String orderId) async {
    final result = await cancelOrderUseCase(OrderParams(orderId: orderId));
    result.fold(
      (failure) => state = OrderError(failure.message),
      (_) => state = OrderInitial(), // reiniciamos estado si fue exitoso
    );
  }

  Future<void> markAsPaid({
    required String orderId,
    required String paymentMethod,
  }) async {
    state = OrderLoading();
    final result = await markOrderAsPaidUseCase(
      MarkOrderAsPaidParams(orderId: orderId, paymentMethod: paymentMethod),
    );
    result.fold(
      (failure) => state = OrderError(failure.message),
      (_) => state = OrderSuccess('Pago registrado correctamente'),
    );
  }

  void resetState() {
    state = OrderInitial();
  }
}
