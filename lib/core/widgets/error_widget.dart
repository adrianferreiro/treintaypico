import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:treintaypico/core/localization/strings.dart';
import 'package:treintaypico/core/styles/app_colors.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback retryCallback;
  const CustomErrorWidget({
    super.key,
    required this.message,
    required this.retryCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.warning_amber, color: AppColors.redAlert),
        SizedBox(height: 2.h),
        Text(message),
        TextButton(onPressed: retryCallback, child: const Text(Strings.retry)),
      ],
    );
  }
}
