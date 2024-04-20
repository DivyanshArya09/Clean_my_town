import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/enums/request_enums.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/Custom_url_launcher.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/features/home/models/user_model.dart';
import 'package:app/ui/custom_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactDetailsCard extends StatelessWidget {
  final UserModel user;
  final RequestType requestType;
  final String requestDate;
  const ContactDetailsCard(
      {super.key,
      required this.user,
      required this.requestDate,
      required this.requestType});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DEFAULT_BORDER_RADIUS),
        border: Border.all(color: const Color.fromARGB(255, 210, 212, 209)),
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
                      BorderRadius.circular(50.0), // Adjust radius as needed
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: CachedNetworkImage(
                    imageUrl: user.profilePicture,
                    fit: BoxFit.fill,
                    errorWidget: (context, url, error) {
                      return const Icon(Icons.person);
                    },
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
                      text: requestType == RequestType.others
                          ? '❝ ${user.name} ❞'
                          : "You",
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
              Text('Date,', style: AppStyles.roboto_14_500_dark),
              CustomSpacers.width14,
              Text(requestDate, style: AppStyles.roboto_14_500_dark),
            ],
          ),
          CustomSpacers.height12,
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: DEFAULT_Horizontal_PADDING,
            ),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
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
                  '+91 ${user.number}',
                  style: AppStyles.activetabStyle,
                ),
              ],
            ),
          ),
          CustomSpacers.height20,
          Visibility(
            visible:
                user.number!.isNotEmpty && requestType == RequestType.others,
            child: CustomButton(
              btnType: ButtonType.secondary,
              prefixIcon: Icon(
                Icons.call,
                color: AppColors.primary,
              ),
              btnTxt: 'Call Now',
              onTap: () {
                if (requestType == RequestType.others) {
                  CustomUrlLauncher.launchPhoneDialer(user.number!);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
