import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:treintaypico/core/domain/usecase/params.dart';
import 'package:treintaypico/features/printing/application/usecases/connect_printer_usecase.dart';
import 'package:treintaypico/features/printing/domain/entities/printer_device_entity.dart';
import 'package:treintaypico/features/printing/presentation/widgets/printer_tile.dart';

// Ajusta este import al path real de tu provider del controller
import 'package:treintaypico/features/printing/application/providers/controllers/printing_controller_provider.dart';

class PrinterList extends ConsumerWidget {
  final List<PrinterDeviceEntity> devices;

  const PrinterList({super.key, required this.devices});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (devices.isEmpty) {
      return const Center(child: Text('No se encontraron dispositivos.'));
    }

    final controller = ref.read(printingControllerProvider.notifier);

    return ListView.separated(
      itemCount: devices.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final d = devices[i];
        return PrinterTile(
          device: d,
          onConnect: () =>
              controller.connect(ConnectPrinterParams(deviceId: d.id)),
          onDisconnect: () => controller.disconnect(NoParams()),
        );
      },
    );
  }
}
