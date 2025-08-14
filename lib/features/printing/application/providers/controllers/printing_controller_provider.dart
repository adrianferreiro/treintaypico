import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/features/printing/application/controllers/printing_controller.dart';
import 'package:treintaypico/features/printing/application/providers/usecases/scan_printers_usecases_providers.dart';
import 'package:treintaypico/features/printing/application/states/printing_state.dart';

final printingControllerProvider =
    StateNotifierProvider<PrintingController, PrintingState>((ref) {
      final scanPrintersUseCase = ref.watch(scanPrinterUsecaseProvider);
      final connectPrinterUseCase = ref.watch(connectPrinterUsecaseProvider);
      final disconnectPrinterUseCase = ref.watch(
        disconnectPrinterUsecaseProvider,
      );
      return PrintingController(
        scanPrintersUseCase: scanPrintersUseCase,
        connectPrinterUsecase: connectPrinterUseCase,
        disconnectPrinterUsecase: disconnectPrinterUseCase,
      );
    });
