import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:treintaypico/features/printing/application/providers/actions/print_actin_provider.dart';
import 'package:treintaypico/features/printing/application/usecases/print_ticket_usecase.dart';

class PrintTestButton extends ConsumerWidget {
  const PrintTestButton({super.key});

  // Construye un ticket MUY básico en ESC/POS para prueba.
  // (Init, texto simple, salto de línea, "cut" suave si la impresora lo soporta)
  List<int> _buildTestBytes() {
    final bytes = <int>[];

    // ESC @  -> Initialize
    bytes.addAll([0x1B, 0x40]);

    // Texto
    final text = '*** TEST DE IMPRESIÓN ***\nHola desde treintaypico!\n\n';
    bytes.addAll(utf8.encode(text));

    // Alimentar unas líneas
    bytes.addAll([0x1B, 0x64, 0x03]); // ESC d n (feed n lines)

    // GS V 1  -> Cut (algunas impresoras lo ignoran si no tienen guillotina)
    bytes.addAll([0x1D, 0x56, 0x01]);

    return bytes;
    // Nota: Cuando integres tu generador real de tickets (con perfil/código de barras/etc),
    // reemplaza esta función por la que uses en tu domain/application.
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final printAction = ref.watch(printActionProvider);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: switch (printAction) {
          AsyncLoading() => null,
          _ => () async {
            final bytes = _buildTestBytes();
            final params = PrintTicketParams(bytes: bytes);
            await runPrintAction(ref, params);
          },
        },
        icon: switch (printAction) {
          AsyncLoading() => const SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          _ => const Icon(Icons.receipt_long),
        },
        label: Text(switch (printAction) {
          AsyncLoading() => 'Imprimiendo...',
          _ => 'Imprimir ticket de prueba',
        }),
      ),
    );
  }
}
