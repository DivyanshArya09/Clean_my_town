import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/app_images.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        color: AppColors.lightGray,
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          elevation: 10,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: DEFAULT_VERTICAL_PADDING,
              horizontal: DEFAULT_Horizontal_PADDING,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.loading,
                  height: 150.h,
                  fit: BoxFit.fitHeight,
                ),
                CustomSpacers.height30,
                Text(
                  'Loading please wait....',
                  style: AppStyles.headingDark,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

showLoadingAlertDialog(BuildContext context,
    {String message = 'Loading please wait....'}) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.loading,
                height: 150.h,
                fit: BoxFit.fitHeight,
              ),
              CustomSpacers.height30,
              Text(
                message,
                style: AppStyles.headingDark,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      });
}
