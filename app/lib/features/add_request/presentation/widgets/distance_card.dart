import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/app_images.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/ui/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DistanceCard extends StatelessWidget {
  const DistanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: DEFAULT_VERTICAL_PADDING,
        horizontal: DEFAULT_Horizontal_PADDING,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(DEFAULT_BORDER_RADIUS),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Walking Distance",
                style: AppStyles.roboto_14_500_dark,
              ),
              Spacer(),
              Image(image: AssetImage(AppImages.distance), height: 30.h),
              CustomSpacers.width12,
              Text('2.00 km', style: AppStyles.activetabStyle),
            ],
          ),
          Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(DEFAULT_BORDER_RADIUS),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: DEFAULT_Horizontal_PADDING,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(DEFAULT_BORDER_RADIUS),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.err,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      height: 30.h,
                      AppImages.walkIcon,
                    ),
                  ),
                  Image.asset(
                    AppImages.rightArrow,
                    height: 30.h,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      AppImages.locationIcon,
                      height: 30.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomSpacers.height20,
          CustomButton(btnTxt: 'Get Directions', onTap: () {}),
        ],
      ),
    );
  }
}
