class PrinterDeviceModel {
  final String id;
  final String name;
  final bool isConnected;

  const PrinterDeviceModel({
    required this.id,
    required this.name,
    required this.isConnected,
  });

  // Si la fuente es un plugin BT:
  factory PrinterDeviceModel.fromPluginMap(Map<String, dynamic> map) {
    return PrinterDeviceModel(
      id: map['macAddress'] ?? map['id'] ?? '',
      name: map['name'] ?? '',
      isConnected: (map['isConnected'] as bool?) ?? false,
    );
  }

  // Si mañana sumás otra fuente (TCP/USB), agregás otro factory:
  // factory PrinterDeviceModel.fromPosPlatform(OtherType r) { ... }
}
