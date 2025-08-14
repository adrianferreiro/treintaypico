import 'package:dartz/dartz.dart';
import 'package:treintaypico/core/domain/usecase/use_case.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/printing/domain/repositories/printer_repository.dart';

class PrintTicketUsecase extends UseCase<Unit, PrintTicketParams> {
  final PrinterRepository repository;

  PrintTicketUsecase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(PrintTicketParams params) {
    return repository.printTicket(params.bytes);
  }
}

class PrintTicketParams {
  final List<int> bytes;

  PrintTicketParams({required this.bytes});
}
