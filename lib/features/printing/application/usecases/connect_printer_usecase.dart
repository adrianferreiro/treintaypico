import 'package:dartz/dartz.dart';
import 'package:treintaypico/core/domain/usecase/use_case.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/printing/domain/repositories/printer_repository.dart';

class ConnectPrinterUsecase extends UseCase<Unit, ConnectPrinterParams> {
  final PrinterRepository repository;

  ConnectPrinterUsecase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ConnectPrinterParams params) {
    return repository.connect(params.deviceId);
  }
}

class ConnectPrinterParams {
  final String deviceId;

  ConnectPrinterParams({required this.deviceId});
}
