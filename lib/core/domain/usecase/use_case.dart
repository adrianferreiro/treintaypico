import 'package:dartz/dartz.dart';
import 'package:treintaypico/core/network/errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
