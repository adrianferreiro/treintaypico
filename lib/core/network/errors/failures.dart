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

final class BluetoothOffFailure extends Failure {
  BluetoothOffFailure({super.message = 'Bluetooth apagado'});
}

final class PermissionDeniedFailure extends Failure {
  PermissionDeniedFailure({super.message = 'Permiso de Bluetooth denegado'});
}

final class DeviceNotFoundFailure extends Failure {
  DeviceNotFoundFailure({super.message = 'Impresora no encontrada'});
}

final class ConnectionTimeoutFailure extends Failure {
  ConnectionTimeoutFailure({super.message = 'Tiempo de conexión agotado'});
}

final class PrintFailure extends Failure {
  PrintFailure({super.message = 'Error al imprimir'});
}

final class PaperOutFailure extends Failure {
  PaperOutFailure({super.message = 'La impresora no tiene papel'});
}

final class UnsupportedProfileFailure extends Failure {
  UnsupportedProfileFailure({super.message = 'Perfil ESC/POS no soportado'});
}
