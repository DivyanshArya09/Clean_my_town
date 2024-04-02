import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/app_images.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/features/add_request/model/request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/styles/app_styles.dart';

class RequestTile extends StatelessWidget {
  final RequestModel request;
  const RequestTile({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 70.h,
                  width: 70.h,
                  decoration: BoxDecoration(
                    color: AppColors.darkGray,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      'https://im.indiatimes.in/media/content/2016/Apr/garbage_1461846819.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                CustomSpacers.width14,
                Text(request.title, style: AppStyles.titleStyle),
              ],
            ),
            CustomSpacers.height10,
            SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              child: Text(
                maxLines: 3,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                'To maintain state and run initialization code only once in Flutter, utilize a StatefulWidget with initState. initState is called exactly once when the widget is inserted into the tree, ensuring initialization occurs just once',
                // request.description,
                style: AppStyles.roboto_14_500_dark,
              ),
            ),
            CustomSpacers.height10,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.markerIcon,
                  height: 30.h,
                ),
                CustomSpacers.width10,
                SizedBox(
                  width: MediaQuery.of(context).size.width * .7,
                  child: Text(
                    softWrap: true,
                    textAlign: TextAlign.start,
                    "Patiala, Patiala Tahsil, Patiala District, Punjab, 147001, India",
                    style: AppStyles.activetabStyle,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('1/04/2024, 8:40 AM', style: AppStyles.ts_14_grey),
                Spacer(),
                Container(
                    alignment: Alignment.center,
                    // height: 30.h,
                    // width: 70.w,
                    padding: EdgeInsets.symmetric(
                        horizontal: DEFAULT_Horizontal_PADDING, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Opened',
                          style: AppStyles.roboto_14_500_light,
                        ),
                        CustomSpacers.width4,
                        Icon(
                          Icons.update,
                          color: AppColors.white,
                        )
                      ],
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}

/**ListTile(
          trailing: Column(
            children: [
              TextButton(
                onPressed: () {},
                child: Text(request.town, style: AppStyles.activetabStyle),
              ),
              CustomSpacers.height10,
              Container(
                alignment: Alignment.center,
                height: 20.h,
                width: 70.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  'opened',
                  style: AppStyles.roboto_14_500_light,
                ),
              )
            ],
          ),
          title: Text(request.title, style: AppStyles.titleStyle),
          subtitle: Text(
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            request.description,
            style: AppStyles.roboto_14_500_dark,
          ),
        ), */
