import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/features/printing/data/adapters/pbt_bluetooth_adapter.dart';
import 'package:treintaypico/features/printing/data/datasources/pbt_printer_datasource.dart';
import 'package:treintaypico/features/printing/data/datasources/printer_datasource.dart';
import 'package:treintaypico/features/printing/data/ports/bluetooth_port.dart';

final bluetoothPortProvider = Provider<BluetoothPort>((ref) {
  return PbtBluetoothAdapter();
});

final printerDatasourceProvider = Provider<PrinterDatasource>((ref) {
  final port = ref.watch(bluetoothPortProvider);
  return PbtPrinterDatasource(port);
});
