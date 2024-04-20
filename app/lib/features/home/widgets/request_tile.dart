import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/app_images.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/enums/request_enums.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/features/requests/presentation/models/request_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/styles/app_styles.dart';

class RequestTile extends StatelessWidget {
  final RequestModel request;
  final VoidCallback onTap;
  const RequestTile({super.key, required this.request, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Material(
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
                      child: CachedNetworkImage(
                        // placeholder: (context, url) => Icon(Icons.photo),
                        imageUrl: request.image,
                        fit: BoxFit.cover,
                        errorListener: (value) {},
                        errorWidget: (context, url, error) {
                          return Icon(Icons.photo, color: AppColors.white);
                        },
                      ),
                    ),
                  ),
                  CustomSpacers.width14,
                  SizedBox(
                      width: MediaQuery.of(context).size.width * .5,
                      child: Text(
                        request.title,
                        style: AppStyles.titleStyle,
                        softWrap: true,
                      )),
                ],
              ),
              CustomSpacers.height10,
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: Text(
                  maxLines: 3,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  request.description,
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
                      request.fullAddress,
                      style: AppStyles.activetabStyle,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(request.dateTime, style: AppStyles.ts_14_grey),
                  Spacer(),
                  statusTab(request.status),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

statusTab(RequestStatus status) {
  return Container(
    width: 120.w,
    height: 40.h,
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(horizontal: DEFAULT_Horizontal_PADDING),
    decoration: BoxDecoration(
      color: status.colorValue,
      borderRadius: BorderRadius.circular(50),
    ),
    child: Text(
      status.textValue,
      style: AppStyles.roboto_14_500_light,
    ),
  );
}
