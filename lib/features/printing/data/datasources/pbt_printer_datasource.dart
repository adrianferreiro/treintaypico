import 'package:treintaypico/core/network/errors/failures.dart';
import 'package:treintaypico/features/printing/data/datasources/printer_datasource.dart';
import 'package:treintaypico/features/printing/data/models/printer_device_model.dart';
import 'package:treintaypico/features/printing/data/ports/bluetooth_port.dart';

class PbtPrinterDatasource implements PrinterDatasource {
  final BluetoothPort port;

  PbtPrinterDatasource(this.port);

  @override
  Future<List<PrinterDeviceModel>> scan() async {
    final raw = await port.getBluetooths();
    return raw.map((m) => PrinterDeviceModel.fromPluginMap(m)).toList();
  }

  @override
  Future<void> connect(String deviceId) async {
    final ok = await port.connect(deviceId);
    if (!ok) throw ConnectionTimeoutFailure();
  }

  @override
  Future<void> disconnect() {
    return port.disconnect();
  }

  @override
  Future<void> sendBytes(List<int> bytes) async {
    final ok = await port.writeBytes(bytes);
    if (!ok) throw PrintFailure();
  }
}
