import 'package:dartz/dartz.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/orders/domain/entities/order_entity.dart';

abstract class OrderRepository {
  Future<Either<Failure, OrderEntity>> getOrderById(String id);
  Future<Either<Failure, void>> markOrderAsPaid({
    required String orderId,
    required String paymentMethod,
  });
  Future<Either<Failure, void>> cancelOrder(String orderId);
}
