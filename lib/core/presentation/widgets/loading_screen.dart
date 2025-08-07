// lib/core/common_widgets/loading_screen.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 2.h),
            Text('Cargando aplicación...', style: TextStyle(fontSize: 14.sp)),
          ],
        ),
      ),
    );
  }
}
