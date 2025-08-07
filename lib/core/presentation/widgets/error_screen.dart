// lib/core/common_widgets/error_screen.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart'; // Mantén Sizer si lo usas para dimensiones

class ErrorScreen extends StatelessWidget {
  final dynamic error; // Puedes pasar el error para mostrarlo
  final StackTrace? stackTrace; // Y el stack trace
  final VoidCallback? onRetry; // Opcional: un callback para reintentar

  const ErrorScreen({
    super.key,
    required this.error,
    this.stackTrace,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(4.w), // Padding responsivo
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 50),
              SizedBox(height: 2.h),
              Text(
                'Error al iniciar la aplicación:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 1.h),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Colors.red),
              ),
              if (stackTrace !=
                  null) // Mostrar stack trace solo en debug o si es necesario
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Text(
                    stackTrace.toString().substring(
                      0,
                      (stackTrace.toString().length > 200
                          ? 200
                          : stackTrace.toString().length),
                    ), // Limitar para no saturar
                    style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                  ),
                ),
              if (onRetry != null)
                Padding(
                  padding: EdgeInsets.only(top: 3.h),
                  child: ElevatedButton(
                    onPressed: onRetry,
                    child: Text(
                      'Reintentar',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
