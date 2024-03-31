import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/ui/bounce-widget.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String btnTxt;
  final double btnHeight;
  final double btnWidth;
  const CustomButton(
      {super.key,
      required this.btnTxt,
      required this.onTap,
      this.btnWidth = DEFAULT_BUTTON_WIDTH,
      this.btnHeight = DEFAULT_BUTTON_HEIGHT});

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: onTap,
      child: Container(
        alignment: Alignment.center,
        width: btnWidth,
        // padding: const  EdgeInsetsDirectional.symmetric(vertical: 16.0, horizontal: 24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DEFAULT_BORDER_RADIUS),
          color: AppColors.primary,
        ),
        height: btnHeight,
        child: Text(
          btnTxt,
          textAlign: TextAlign.center,
          style: AppStyles.roboto_14_500_light,
        ),
      ),
    );
  }
}
