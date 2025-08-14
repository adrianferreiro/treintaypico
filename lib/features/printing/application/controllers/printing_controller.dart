import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/domain/usecase/params.dart';
import 'package:treintaypico/features/printing/application/states/printing_state.dart';
import 'package:treintaypico/features/printing/application/usecases/connect_printer_usecase.dart';
import 'package:treintaypico/features/printing/application/usecases/disconnect_printer_usecase.dart';
import 'package:treintaypico/features/printing/application/usecases/scan_printers_usecase.dart';

class PrintingController extends StateNotifier<PrintingState> {
  final ScanPrintersUsecase scanPrintersUseCase;
  final ConnectPrinterUsecase connectPrinterUsecase;
  final DisconnectPrinterUsecase disconnectPrinterUsecase;
  bool _isScanning = false;

  PrintingController({
    required this.scanPrintersUseCase,
    required this.connectPrinterUsecase,
    required this.disconnectPrinterUsecase,
  }) : super(const PrintingInitial());

  Future<void> scan(NoParams params) async {
    if (_isScanning) return;
    _isScanning = true;

    state = const PrintingLoading();
    final result = await scanPrintersUseCase(params);

    state = result.fold(
      (failure) => PrintingError(failure),
      (devices) => PrintingLoaded(devices),
    );

    _isScanning = false;
  }

  Future<void> connect(ConnectPrinterParams params) async {
    state = const PrintingLoading();
    final result = await connectPrinterUsecase.call(params);
    state = result.fold(
      (failure) => PrintingError(failure),
      (_) => PrintingConnected(params.deviceId),
    );
  }

  Future<void> disconnect(NoParams params) async {
    state = const PrintingLoading();
    final result = await disconnectPrinterUsecase.call(params);
    state = result.fold(
      (failure) => PrintingError(failure),
      (_) => PrintingDisconnected(),
    );
  }
}
