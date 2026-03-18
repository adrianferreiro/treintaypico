// EVNTS POS — Servicio de impresión de tickets/recibos para pedidos.
// Usa nyx_printer_v2 para generar tickets físicos (impresora térmica) con
// cabecera, QR del pedido, detalle de ítems y total.

import 'package:nyx_printer_v2/nyx_printer.dart';
import 'package:treintaypico/features/orders/domain/entities/order_entity.dart';

/// Servicio que genera e imprime el ticket de un pedido en impresora térmica.
/// Formato: cabecera EVNTS POS, número de pedido, QR, cliente, fecha, método de pago,
/// detalle de ítems y total. Retorna [true] si la impresión fue exitosa.
class TicketPrinterService {
  static const int _lineWidth = 32;
  static const String _separator = '--------------------------------';
  static const String _separatorDouble = '================================';

  final NyxPrinter _printer = NyxPrinter();

  /// Imprime el ticket del pedido. Retorna true si fue exitoso.
  Future<bool> printTicket(OrderEntity order) async {
      try {
        // 1. Header: "EVNTS POS" — center, bold, size 36
        await _printer.printText('EVNTS POS', textFormat: NyxTextFormat(
          textSize: 36,
          align: NyxAlign.center,
          style: NyxFontStyle.bold,
        ));

        // 2. Order number — center, size 18
        await _printer.printText('Order #${order.orderNumber}', textFormat: NyxTextFormat(
          textSize: 18,
          align: NyxAlign.center,
        ));

        // 3. Separador
        await _printer.printText(_separator, textFormat: NyxTextFormat(
          align: NyxAlign.center,
        ));

        // 4. QR Code del order number
        await _printer.printQrCode(order.orderNumber, width: 250, height: 250);

        // 5. Info cliente — center, size 16/14
        await _printer.printText('Cliente: ${order.userName}', textFormat: NyxTextFormat(
          textSize: 16,
          align: NyxAlign.center,
        ));

        // 6. Fecha (momento del pago)
        final date = order.updatedAt;
        final dateStr = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
        await _printer.printText('Fecha: $dateStr', textFormat: NyxTextFormat(
          textSize: 14,
          align: NyxAlign.center,
        ));

        // 7. Método de pago
        await _printer.printText('Pagado: ${_paymentMethodLabel(order.paymentMethod)}', textFormat: NyxTextFormat(
          textSize: 14,
          align: NyxAlign.center,
        ));

        // 8. Separador doble
        await _printer.printText(_separatorDouble, textFormat: NyxTextFormat(
          align: NyxAlign.center,
        ));

        // 9. Título items — center, bold
        await _printer.printText('Detalle del Pedido', textFormat: NyxTextFormat(
          textSize: 16,
          align: NyxAlign.center,
          style: NyxFontStyle.bold,
        ));

        // 10. Loop items: nombre + precio (alineado a _lineWidth)
        for (final item in order.items) {
          final name = item.productName;
          final price = '\$${item.subtotal.toStringAsFixed(3)}';
          final padding = _lineWidth - name.length - price.length;
          final spaces = padding > 0 ? ' ' * padding : ' ';
          await _printer.printText('$name$spaces$price', textFormat: NyxTextFormat(
            textSize: 16,
          ));
        }

        // 11. Separador
        await _printer.printText(_separator, textFormat: NyxTextFormat(
          align: NyxAlign.center,
        ));

        // 12. TOTAL label
        await _printer.printText('TOTAL', textFormat: NyxTextFormat(
          textSize: 14,
          align: NyxAlign.center,
        ));

        // 13. Total amount — center, bold, big
        await _printer.printText('\$${order.totalAmount.toStringAsFixed(3)}', textFormat: NyxTextFormat(
          textSize: 38,
          align: NyxAlign.center,
          style: NyxFontStyle.bold,
        ));

        // 14. Items count
        await _printer.printText('${order.items.length} items', textFormat: NyxTextFormat(
          textSize: 14,
          align: NyxAlign.center,
        ));

        // 15. Espacio final (feed paper)
        await _printer.printText('\n\n\n');

        return true;
      } catch (e) {
        return false;
      }
  }

  static String _paymentMethodLabel(PaymentMethod? method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Efectivo';
      case PaymentMethod.card:
        return 'Tarjeta';
      case PaymentMethod.transfer:
        return 'Transferencia';
      case null:
        return 'Efectivo';
    }
  }
}