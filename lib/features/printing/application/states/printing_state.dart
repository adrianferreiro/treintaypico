import 'package:treintaypico/features/printing/domain/entities/printer_device_entity.dart';
import 'package:treintaypico/core/network/errors/failures.dart';

sealed class PrintingState {
  const PrintingState();
}

class PrintingInitial extends PrintingState {
  const PrintingInitial();
}

class PrintingLoading extends PrintingState {
  const PrintingLoading();
}

class PrintingLoaded extends PrintingState {
  final List<PrinterDeviceEntity> printerDevices;
  const PrintingLoaded(this.printerDevices);
}

class PrintingError extends PrintingState {
  final Failure failure;
  const PrintingError(this.failure);
}

class PrintingConnected extends PrintingState {
  final String deviceId;
  PrintingConnected(this.deviceId);
}

class PrintingDisconnected extends PrintingState {
  const PrintingDisconnected();
}
