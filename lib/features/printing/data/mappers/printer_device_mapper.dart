import 'package:treintaypico/features/printing/data/models/printer_device_model.dart';
import 'package:treintaypico/features/printing/domain/entities/printer_device_entity.dart';

class PrinterDeviceMapper {
  static PrinterDeviceEntity toEntity(PrinterDeviceModel m) {
    return PrinterDeviceEntity(
      id: m.id,
      name: m.name,
      isConnected: m.isConnected,
    );
  }
}

extension PrinterDeviceModelX on PrinterDeviceModel {
  PrinterDeviceEntity toEntity() => PrinterDeviceMapper.toEntity(this);
}

extension PrinterDeviceModelListX on List<PrinterDeviceModel> {
  List<PrinterDeviceEntity> toEntityList() =>
      map(PrinterDeviceMapper.toEntity).toList();
}
