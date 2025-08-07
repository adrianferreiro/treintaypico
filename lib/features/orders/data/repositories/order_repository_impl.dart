import 'package:dartz/dartz.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/core/network/exceptions/exceptions.dart';
import 'package:treintaypico/features/orders/data/datasources/order_datasource.dart';
import 'package:treintaypico/features/orders/domain/entities/order_entity.dart';
import 'package:treintaypico/features/orders/domain/repositories/order_repository.dart';
import 'package:treintaypico/features/orders/data/mappers/order_mapper.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderDatasource datasource;

  OrderRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String id) async {
    try {
      final model = await datasource.getOrderById(id);
      return Right(model.toEntity());
    } on NotFoundException {
      return Left(NotFoundFailure(message: 'Orden no encontrada'));
    } on AlreadyScannedException {
      return Left(AlreadyScannedFailure());
    } on StorageException {
      return Left(StorageFailure());
    } catch (e) {
      return Left(UnexpectedFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markOrderAsPaid({
    required String orderId,
    required String paymentMethod,
  }) async {
    try {
      await datasource.markOrderAsPaid(
        orderId: orderId,
        paymentMethod: paymentMethod,
      );
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: 'No se pudo registrar el pago'));
    }
  }

  @override
  Future<Either<Failure, void>> cancelOrder(String orderId) async {
    try {
      await datasource.cancelOrder(orderId);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: 'No se pudo cancelar la orden'));
    }
  }
}
