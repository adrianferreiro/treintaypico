import 'package:flutter/material.dart';
import 'package:treintaypico/features/printing/domain/entities/printer_device_entity.dart';

class PrinterTile extends StatelessWidget {
  final PrinterDeviceEntity device;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  const PrinterTile({
    super.key,
    required this.device,
    required this.onConnect,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    final isConnected = device.isConnected;

    return Card(
      child: ListTile(
        leading: Icon(isConnected ? Icons.print : Icons.print_disabled),
        title: Text(device.name.isNotEmpty ? device.name : '(Sin nombre)'),
        subtitle: Text('ID: ${device.id}'),
        trailing: isConnected
            ? OutlinedButton.icon(
                onPressed: onDisconnect,
                icon: const Icon(Icons.link_off),
                label: const Text('Desconectar'),
              )
            : ElevatedButton.icon(
                onPressed: onConnect,
                icon: const Icon(Icons.link),
                label: const Text('Conectar'),
              ),
      ),
    );
  }
}
