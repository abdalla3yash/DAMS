import 'package:dams/core/theme/colors.dart';
import 'package:flutter/material.dart';

extension CustomThemeData on ThemeData {
  BoxDecoration get containerDecoration => BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            offset: const Offset(3, 1),
            blurRadius: 2.5,
            blurStyle: BlurStyle.normal,
            color: AppColors.primary.withOpacity(0.3),
            spreadRadius: 1.3,
          ),
        ],
      );
}
