import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrWidget extends StatelessWidget {
  final String txt;
  final VoidCallback ontap;
  const OrWidget({super.key, required this.ontap, required this.txt});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        CustomSpacers.height24,
        SizedBox(
          height: 40.h,
          width: width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 1,
                width: width * 0.35,
                color: AppColors.darkGray,
              ),
              CustomSpacers.width6,
              Text('or', style: AppStyles.roboto_14_500_dark),
              CustomSpacers.width6,
              Container(
                height: 1,
                width: width * 0.35,
                color: AppColors.darkGray,
              )
            ],
          ),
        ),
        CustomSpacers.height24,
        _buildAlreadyHaveAnAccount(),
      ],
    );
  }

  Widget _buildAlreadyHaveAnAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Already have an Account ? ',
          style: AppStyles.roboto_14_500_dark,
        ),
        TextButton(
          onPressed: ontap,
          child: Text(
            txt,
            style:
                AppStyles.roboto_14_500_dark.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
