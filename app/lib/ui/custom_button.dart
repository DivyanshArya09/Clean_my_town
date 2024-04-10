import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/ui/bounce-widget.dart';
import 'package:flutter/material.dart';

enum ButtonType { primary, secondary }

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String btnTxt;
  final double btnHeight;
  final double btnWidth;
  final ButtonType? btnType;
  final double? btnRadius;
  const CustomButton(
      {super.key,
      required this.btnTxt,
      required this.onTap,
      this.btnType = ButtonType.primary,
      this.btnRadius = DEFAULT_BORDER_RADIUS,
      this.btnWidth = DEFAULT_BUTTON_WIDTH,
      this.btnHeight = DEFAULT_BUTTON_HEIGHT});

  @override
  Widget build(BuildContext context) {
    return _buildButton(btnType!);
  }

  _buildPrimaryButton() {
    return BouncingWidget(
      onPressed: onTap,
      child: Container(
        alignment: Alignment.center,
        width: btnWidth,
        // padding: const  EdgeInsetsDirectional.symmetric(vertical: 16.0, horizontal: 24.0),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(btnRadius ?? DEFAULT_BORDER_RADIUS),
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

  _buildSecondaryButton() {
    return BouncingWidget(
      onPressed: onTap,
      child: Container(
        alignment: Alignment.center,
        width: btnWidth,
        // padding: const  EdgeInsetsDirectional.symmetric(vertical: 16.0, horizontal: 24.0),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(btnRadius ?? DEFAULT_BORDER_RADIUS),
          border: Border.all(
            color: AppColors.primary,
            width: 1.0,
          ),
        ),
        height: btnHeight,
        child: Text(
          btnTxt,
          textAlign: TextAlign.center,
          style:
              AppStyles.roboto_14_500_light.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }

  _buildButton(ButtonType btnType) {
    switch (btnType) {
      case ButtonType.primary:
        return _buildPrimaryButton();
      case ButtonType.secondary:
        return _buildSecondaryButton();
      default:
        return _buildPrimaryButton();
    }
  }
}
