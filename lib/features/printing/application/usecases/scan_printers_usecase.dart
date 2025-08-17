import 'package:dartz/dartz.dart';
import 'package:treintaypico/core/domain/usecase/params.dart';
import 'package:treintaypico/core/domain/usecase/use_case.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/printing/domain/entities/printer_device_entity.dart';
import 'package:treintaypico/features/printing/domain/repositories/printer_repository.dart';

class ScanPrintersUsecase extends UseCase<List<PrinterDeviceEntity>, NoParams> {
  final PrinterRepository repository;

  ScanPrintersUsecase(this.repository);

  @override
  Future<Either<Failure, List<PrinterDeviceEntity>>> call(NoParams params) {
    return repository.scan();
  }
}
