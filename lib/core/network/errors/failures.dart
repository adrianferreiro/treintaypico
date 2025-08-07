sealed class Failure {
  final String message;

  Failure({required this.message});
}

final class ApiFailure extends Failure {
  ApiFailure({super.message = 'Error en la petición'});
}

final class NotFoundFailure extends Failure {
  NotFoundFailure({super.message = 'QR Code no encontrado'});
}

final class AlreadyScannedFailure extends Failure {
  AlreadyScannedFailure({super.message = 'Éste código QR ya fue escaneado'});
}

final class StorageFailure extends Failure {
  StorageFailure({super.message = 'Error al acceder al almacenamiento local'});
}

class UnexpectedFailure extends Failure {
  UnexpectedFailure(String message) : super(message: message);
}
