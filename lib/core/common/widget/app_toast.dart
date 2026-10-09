import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:uni_help/core/theme/app_colors.dart';
abstract class AppToast {
  static void showToast({
    required BuildContext context,
    required String title,
    required String description,
    required ToastificationType type,
  }) {
    toastification.show(
      context: context,
      type: type,
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      description: Text(
        description,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      primaryColor: Colors.white,
      autoCloseDuration: const Duration(seconds: 3),
      progressBarTheme: ProgressIndicatorThemeData(
        color: type == ToastificationType.success
            ? Colors.green
            : type == ToastificationType.info
            ? AppColors.primaryColor
            : type == ToastificationType.warning
            ? Colors.orange
            : Colors.red,
      ),
      showProgressBar: true,
      backgroundColor: type == ToastificationType.success
          ? Colors.green
          : type == ToastificationType.info
          ? AppColors.primaryColor
          : type == ToastificationType.warning
          ? Colors.orange
          : Colors.red,
      foregroundColor: Colors.white,
    );
  }
}
