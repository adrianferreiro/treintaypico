import 'package:dartz/dartz.dart';
import 'package:treintaypico/core/domain/usecase/params.dart';
import 'package:treintaypico/core/domain/usecase/use_case.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/printing/domain/repositories/printer_repository.dart';

class DisconnectPrinterUsecase extends UseCase<Unit, NoParams> {
  final PrinterRepository repository;

  DisconnectPrinterUsecase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return repository.disconnect();
  }
}
