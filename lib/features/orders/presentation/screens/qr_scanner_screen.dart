import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:treintaypico/core/styles/app_colors.dart';




class QrScannerScreen extends StatefulWidget{
  const QrScannerScreen({ super.key });

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();

}


class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _scanned = false;

  @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Escanear QR'),
          backgroundColor: AppColors.darkBackground,
          foregroundColor: AppColors.textPrimary,
        ),
        body: MobileScanner(
          controller: _controller,
          onDetect: (BarcodeCapture capture) {
            if (_scanned) return;
            final rawValue = capture.barcodes.firstOrNull?.rawValue;
            if(rawValue !=null){
              _scanned = true;
              Navigator.pop(context, rawValue);
            }
          },
        ),
      );
    }
}