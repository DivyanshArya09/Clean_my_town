import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/ui/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactDetailsCard extends StatelessWidget {
  const ContactDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(DEFAULT_BORDER_RADIUS),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: DEFAULT_Horizontal_PADDING,
      ),
      child: Column(
        children: [
          CustomSpacers.height10,
          Row(
            children: [
              Container(
                height: 35.h,
                width: 35.h,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius:
                      BorderRadius.circular(25.0), // Adjust radius as needed
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://www.shutterstock.com/image-photo/head-shot-portrait-close-smiling-600nw-1714666150.jpg',
                    ),
                    fit:
                        BoxFit.cover, // Adjust fit as needed (cover or contain)
                  ),
                ),
              ),
              CustomSpacers.width20,
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Requested By,  ',
                      style: AppStyles.roboto_16_600_dark,
                    ),
                    TextSpan(
                      text: '❝Divyansh arya❞',
                      style: AppStyles.activetabStyle.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
          CustomSpacers.height12,
          Row(
            children: [
              Text('Opened Since,', style: AppStyles.roboto_14_500_dark),
              CustomSpacers.width14,
              Text('23/ 06/ 2022,  4:30 PM',
                  style: AppStyles.roboto_14_500_dark),
            ],
          ),
          CustomSpacers.height12,
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: DEFAULT_Horizontal_PADDING,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Text(
                  'Phone Number',
                  style: AppStyles.roboto_14_500_dark,
                ),
                Spacer(),
                Text(
                  '+91 9876543210',
                  style: AppStyles.activetabStyle,
                ),
              ],
            ),
          ),
          CustomSpacers.height20,
          CustomButton(
            prefixIcon: Icon(
              Icons.call,
              color: AppColors.white,
            ),
            btnTxt: 'Call Now',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
