import 'package:dartz/dartz.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/printing/data/datasources/printer_datasource.dart';
import 'package:treintaypico/features/printing/data/mappers/printer_device_mapper.dart';
import 'package:treintaypico/features/printing/domain/entities/printer_device_entity.dart';
import 'package:treintaypico/features/printing/domain/repositories/printer_repository.dart';

class PrinterRepositoryImpl implements PrinterRepository {
  final PrinterDatasource datasource;

  PrinterRepositoryImpl(this.datasource);

  @override
  F<List<PrinterDeviceEntity>> scan() async {
    try {
      final models = await datasource.scan();
      final entities = models.toEntityList();
      return Right(entities);
    } catch (e) {
      return Left(UnexpectedFailure('Fallo al escanear la impresora $e'));
    }
  }

  @override
  F<Unit> connect(String deviceId) async {
    try {
      await datasource.connect(deviceId);
      return const Right(unit);
    } catch (e) {
      return Left(UnexpectedFailure('No se pudo conectar $e'));
    }
  }

  @override
  F<Unit> disconnect() async {
    try {
      await datasource.disconnect();
      return const Right(unit);
    } catch (e) {
      return Left(UnexpectedFailure('No se pudo desconectar $e'));
    }
  }

  @override
  F<Unit> printTicket(List<int> bytes) async {
    try {
      await datasource.sendBytes(bytes);
      return const Right(unit);
    } catch (e) {
      return Left(UnexpectedFailure('No se pudo imprimir $e'));
    }
  }
}
