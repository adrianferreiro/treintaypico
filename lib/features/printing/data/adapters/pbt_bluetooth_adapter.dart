import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:treintaypico/features/printing/data/ports/bluetooth_port.dart';

class PbtBluetoothAdapter implements BluetoothPort {
  @override
  Future<List<Map<String, dynamic>>> getBluetooths() async {
    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;

    return listResult.map((bluetooth) {
      return {'name': bluetooth.name, 'macAddress': bluetooth.macAdress};
    }).toList();
  }

  @override
  Future<bool> connect(String mac) async {
    return PrintBluetoothThermal.connect(macPrinterAddress: mac);
  }

  @override
  Future<void> disconnect() async {
    await PrintBluetoothThermal.disconnect;
  }

  @override
  Future<bool> writeBytes(List<int> bytes) async {
    return PrintBluetoothThermal.writeBytes(bytes);
  }
}
