import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/features/printing/application/providers/datasources/printer_datasource_provider.dart';
import 'package:treintaypico/features/printing/data/repositories/printer_repository_impl.dart';
import 'package:treintaypico/features/printing/domain/repositories/printer_repository.dart';

final printerRepositoryProvider = Provider<PrinterRepository>((ref) {
  final datasource = ref.watch(printerDatasourceProvider);
  return PrinterRepositoryImpl(datasource);
});
