import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/features/printing/application/providers/repositories/printer_repository_provider.dart';
import 'package:treintaypico/features/printing/application/usecases/connect_printer_usecase.dart';
import 'package:treintaypico/features/printing/application/usecases/disconnect_printer_usecase.dart';
import 'package:treintaypico/features/printing/application/usecases/print_ticket_usecase.dart';
import 'package:treintaypico/features/printing/application/usecases/scan_printers_usecase.dart';

final scanPrinterUsecaseProvider = Provider<ScanPrintersUsecase>((ref) {
  final repository = ref.watch(printerRepositoryProvider);
  return ScanPrintersUsecase(repository);
});

final connectPrinterUsecaseProvider = Provider<ConnectPrinterUsecase>((ref) {
  final repository = ref.watch(printerRepositoryProvider);
  return ConnectPrinterUsecase(repository);
});

final disconnectPrinterUsecaseProvider = Provider<DisconnectPrinterUsecase>((
  ref,
) {
  final repository = ref.watch(printerRepositoryProvider);
  return DisconnectPrinterUsecase(repository);
});

final printTicketUsecaseProvider = Provider<PrintTicketUsecase>((ref) {
  final repository = ref.watch(printerRepositoryProvider);
  return PrintTicketUsecase(repository);
});
