import 'package:app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyles {
  static TextStyle activetabStyle = const TextStyle(
    color: AppColors.primary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static TextStyle roboto_14_500_light = TextStyle(
    color: AppColors.white,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static TextStyle ts_14_grey = TextStyle(
    color: AppColors.darkGray,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static TextStyle roboto_16_700_light = TextStyle(
    color: AppColors.white,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );
  static TextStyle roboto_16_500_dark = TextStyle(
    color: AppColors.black,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  static TextStyle roboto_16_400_dark = TextStyle(
    color: AppColors.black,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  static TextStyle roboto_16_600_dark = TextStyle(
    color: AppColors.black,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static TextStyle headingLight = TextStyle(
    color: AppColors.white,
    fontSize: 21,
    fontWeight: FontWeight.w600,
  );
  static TextStyle heading2Light = TextStyle(
    color: AppColors.primary,
    fontSize: 30.sp,
    fontWeight: FontWeight.w600,
  );
  static TextStyle headingDark = const TextStyle(
    color: AppColors.black,
    fontSize: 21,
    fontWeight: FontWeight.w600,
  );
  static TextStyle roboto_14_500_dark = const TextStyle(
    color: AppColors.black,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static TextStyle roboto_14_400_dark = const TextStyle(
    color: Color.fromARGB(255, 113, 116, 113),
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static TextStyle inActivetabStyle = const TextStyle(
    color: AppColors.black,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const titleStyle16 = TextStyle(
    color: AppColors.black,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static const titleStyle = TextStyle(
    color: AppColors.black,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  static const appBarStyle = TextStyle(
    color: AppColors.black,
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );
}
