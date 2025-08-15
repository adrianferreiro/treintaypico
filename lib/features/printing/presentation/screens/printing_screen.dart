import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:treintaypico/core/domain/usecase/params.dart';
import 'package:treintaypico/features/printing/application/states/printing_state.dart';
import 'package:treintaypico/features/printing/application/providers/actions/print_actin_provider.dart';
import 'package:treintaypico/features/printing/presentation/widgets/printer_list.dart';
import 'package:treintaypico/features/printing/presentation/widgets/print_test_button.dart';

import 'package:treintaypico/features/printing/application/providers/controllers/printing_controller_provider.dart';

class PrintingScreen extends ConsumerStatefulWidget {
  static const name = 'printing-screen';
  static const path = '/printing';

  const PrintingScreen({super.key});

  @override
  ConsumerState<PrintingScreen> createState() => _PrintingScreenState();
}

class _PrintingScreenState extends ConsumerState<PrintingScreen> {
  @override
  void initState() {
    super.initState();

    // Dispara un escaneo inicial al abrir la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = ref.read(printingControllerProvider.notifier);
      controller.scan(NoParams());
    });

    // Escucha el resultado de impresión para mostrar SnackBars
    ref.listen(printActionProvider, (prev, next) {
      next.when(
        data: (_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ticket enviado a la impresora')),
            );
          }
        },
        loading: () {},
        error: (err, __) {
          final msg = err.toString();
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error al imprimir: $msg')));
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(printingControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Impresoras Bluetooth'),
        actions: [
          IconButton(
            tooltip: 'Reescanear',
            onPressed: () {
              final controller = ref.read(printingControllerProvider.notifier);
              controller.scan(NoParams());
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: switch (state) {
        PrintingInitial() => const _CenteredHint(
          'Pulsa “Reescanear” para buscar impresoras.',
        ),
        PrintingLoading() => const Center(child: CircularProgressIndicator()),
        PrintingError(failure: final f) => _ErrorView(
          message: f.message,
          onRetry: () {
            final controller = ref.read(printingControllerProvider.notifier);
            controller.scan(NoParams());
          },
        ),
        PrintingLoaded(printerDevices: final devices) => Padding(
          padding: const EdgeInsets.all(12),
          child: PrinterList(devices: devices),
        ),
        PrintingConnected(deviceId: final id) => _ConnectedView(
          deviceId: id,
          onDisconnect: () {
            final controller = ref.read(printingControllerProvider.notifier);
            controller.disconnect(NoParams());
          },
        ),
        PrintingDisconnected() => const _CenteredHint(
          'Desconectado. Vuelve a conectar o reescanear.',
        ),
      },

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: PrintTestButton(), // Botón para imprimir ticket de prueba
        ),
      ),
    );
  }
}

class _CenteredHint extends StatelessWidget {
  final String text;
  const _CenteredHint(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text, textAlign: TextAlign.center));
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ocurrió un error:\n$message', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectedView extends ConsumerWidget {
  final String deviceId;
  final VoidCallback onDisconnect;

  const _ConnectedView({required this.deviceId, required this.onDisconnect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bluetooth_connected, size: 48),
          const SizedBox(height: 8),
          Text(
            'Conectado a:\n$deviceId',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onDisconnect,
            icon: const Icon(Icons.link_off),
            label: const Text('Desconectar'),
          ),
          const SizedBox(height: 24),
          // Botón de prueba abajo (en el bottomNavigationBar de la pantalla)
        ],
      ),
    );
  }
}
