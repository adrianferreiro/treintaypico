import 'package:treintaypico/features/printing/data/models/printer_device_model.dart';

abstract class PrinterDatasource {
  Future<List<PrinterDeviceModel>> scan();
  Future<void> connect(String deviceId);
  Future<void> disconnect();
  Future<void> sendBytes(List<int> bytes);
}
