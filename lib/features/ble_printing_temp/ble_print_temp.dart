// lib/features/ble_printing_temp/ble_print_temp.dart
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:treintaypico/features/orders/domain/entities/order_entity.dart';

class BlePrintTemp {
  static const MethodChannel _ch = MethodChannel('walkprint.intent');

  /// Genera una imagen PNG (ancho ~384 px, típico 58mm) a partir de un OrderEntity.
  static Future<Uint8List> buildOrderPng(
    OrderEntity order, {
    int width = 384,
    int padding = 16,
  }) async {
    // Altura aproximada (crecemos si hace falta)
    int height = 120 + (order.items.length * 56) + 120;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    );

    // Fondo blanco
    final bg = Paint()..color = const Color(0xFFFFFFFF);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
      bg,
    );

    double y = padding.toDouble();

    // Título centrado
    y += _drawText(
      canvas,
      '*** COMPROBANTE ***',
      width,
      y,
      fontSize: 26,
      weight: FontWeight.w700,
      align: TextAlign.center,
    );

    y += 6;
    _drawLine(canvas, 0, y, width.toDouble(), y, 2);
    y += 12;

    // Datos generales
    y += _drawText(
      canvas,
      'Pedido: ${order.orderNumber}',
      width,
      y,
      fontSize: 18,
    );
    y += _drawText(
      canvas,
      'Estado: ${order.status.name}',
      width,
      y,
      fontSize: 18,
    );
    y += _drawText(canvas, 'Fecha: ${DateTime.now()}', width, y, fontSize: 16);

    y += 8;
    _drawLine(canvas, 0, y, width.toDouble(), y, 1);
    y += 8;

    // Encabezado de productos
    y += _drawText(
      canvas,
      'Producto                Cant   P.U.     Subt.',
      width,
      y,
      fontSize: 16,
      weight: FontWeight.w600,
    );

    // Items
    for (final it in order.items) {
      final name = it.productName.length > 20
          ? '${it.productName.substring(0, 20)}…'
          : it.productName;
      final line =
          '${_padRight(name, 22)} ${_padLeft(it.quantity.toString(), 4)}  '
          '${_padLeft('\$${it.unitPrice}', 7)}  ${_padLeft('\$${it.subtotal}', 8)}';
      y += _drawText(canvas, line, width, y, fontSize: 16, mono: true);
    }

    y += 8;
    _drawLine(canvas, 0, y, width.toDouble(), y, 1);
    y += 8;

    // Total destacado
    y += _drawText(
      canvas,
      'TOTAL: \$${order.totalAmount}',
      width,
      y,
      fontSize: 20,
      weight: FontWeight.w700,
      align: TextAlign.right,
    );

    y += 24;
    y += _drawText(
      canvas,
      '¡Gracias por su compra!',
      width,
      y,
      fontSize: 18,
      align: TextAlign.center,
    );

    // “Feed” para corte manual
    y += 40;

    // Render final con la altura usada
    final picture = recorder.endRecording();
    final image = await picture.toImage(width, y.toInt() + padding);
    final bd = await image.toByteData(format: ui.ImageByteFormat.png);
    return bd!.buffer.asUint8List();
  }

  /// Abre una app externa para imprimir la imagen (por defecto intenta Thermer).
  /// Si no sabés el package, dejá null y abrirá un chooser.
  static Future<void> openExternalPrinter({
    required Uint8List pngBytes,
    String? packageName, // ej: "com.thermer.print" (ajusta al real)
    String fileName = 'ticket.png',
    String mime = 'image/png',
  }) async {
    await _ch.invokeMethod('open', {
      'bytes': pngBytes,
      'mime': mime,
      'filename': fileName,
      if (packageName != null) 'package': packageName,
    });
  }

  // ==== helpers de dibujo ====

  static double _drawText(
    Canvas canvas,
    String text,
    int width,
    double top, {
    double fontSize = 18,
    FontWeight weight = FontWeight.w400,
    TextAlign align = TextAlign.left,
    bool mono = false,
  }) {
    final style = ui.TextStyle(
      color: const Color(0xFF000000),
      fontSize: fontSize,
      fontWeight: weight,
      // Nota: no es monoespaciada real, pero ayuda a alinear.
      fontFamily: mono ? 'monospace' : null,
    );
    final pb = ui.ParagraphBuilder(ui.ParagraphStyle(textAlign: align))
      ..pushStyle(style)
      ..addText(text);
    final p = pb.build()
      ..layout(ui.ParagraphConstraints(width: width.toDouble()));
    canvas.drawParagraph(p, Offset(0, top));
    return p.height + 6;
  }

  static void _drawLine(
    Canvas c,
    double x1,
    double y1,
    double x2,
    double y2,
    double w,
  ) {
    final paint = Paint()
      ..color = const Color(0xFF000000)
      ..strokeWidth = w;
    c.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
  }

  static String _padRight(String s, int len) =>
      s.length >= len ? s : s + ' ' * (len - s.length);
  static String _padLeft(String s, int len) =>
      s.length >= len ? s : ' ' * (len - s.length) + s;
}
