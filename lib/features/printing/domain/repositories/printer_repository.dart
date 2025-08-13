import 'package:dartz/dartz.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/printing/domain/entities/printer_device_entity.dart';

typedef F<T> = Future<Either<Failure, T>>;

abstract class PrinterRepository {
  F<List<PrinterDeviceEntity>> scan();
  F<Unit> connect(String deviceId);
  F<Unit> disconnect();
  F<Unit> printTicket(List<int> bytes);
}
