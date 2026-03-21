import 'package:dartz/dartz.dart';
import 'package:treintaypico/core/domain/usecase/use_case.dart';
import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/events/domain/repositories/event_repository.dart';

class CreateEventUseCase extends UseCase<void, CreateEventParams> {
  final EventRepository repository;

  CreateEventUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(CreateEventParams params) {
    return repository.createEvent(
      name: params.name,
      date: params.date,
      companyId: params.companyId,
      venueId: params.venueId,
      frontpage: params.frontpage,
      logo: params.logo,
      categories: params.categories,
    );
  }
}

class CreateEventParams {
  final String name;
  final DateTime date;
  final String companyId;
  final String venueId;
  final String frontpage;
  final String logo;
  final List<String> categories;

  const CreateEventParams({
    required this.name,
    required this.date,
    required this.companyId,
    required this.venueId,
    required this.frontpage,
    required this.logo,
    required this.categories,
  });
}
