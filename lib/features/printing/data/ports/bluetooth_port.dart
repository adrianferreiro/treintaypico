abstract class BluetoothPort {
  Future<List<Map<String, dynamic>>> getBluetooths();
  Future<bool> connect(String mac);
  Future<void> disconnect();
  Future<bool> writeBytes(List<int> bytes);
}
