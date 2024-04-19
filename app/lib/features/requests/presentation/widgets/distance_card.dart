import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/app_images.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/enums/map_enums.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/core/utils/toast_utils.dart';
import 'package:app/features/requests/presentation/blocs/map_bloc/map_bloc.dart';
import 'package:app/features/requests/presentation/models/request_model.dart';
import 'package:app/ui/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class DistanceCard extends StatefulWidget {
  final Coordinates destination;
  final MapBloc mapBloc;
  const DistanceCard({
    super.key,
    required this.mapBloc,
    required this.destination,
  });

  @override
  State<DistanceCard> createState() => _DistanceCardState();
}

class _DistanceCardState extends State<DistanceCard> {
  MapMode _mapMode = MapMode.WALKING;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapState>(
      bloc: widget.mapBloc,
      listener: (context, state) {
        if (state is CalculateDistanceInKMSuccess) {
          _mapMode = _getMapMode(state.distance, state.unit);
        }

        if (state is CalculateDistanceInKMFailed) {
          ToastHelpers.showToast(state.message);
        }

        if (state is MapError) {
          ToastHelpers.showToast("Failed to Open Map");
        }
      },
      buildWhen: (previous, current) =>
          current is CalculateDistanceInKMSuccess ||
          current is CalculateDistanceInKMFailed ||
          current is CalculateDistanceInMetersLoading,
      builder: (context, state) {
        if (state is CalculateDistanceInKMSuccess) {
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
                      _mapMode.textValue,
                      style: AppStyles.roboto_14_500_dark,
                    ),
                    Spacer(),
                    Image(image: AssetImage(AppImages.distance), height: 30.h),
                    CustomSpacers.width12,
                    Text(
                      '${state.distance.toStringAsFixed(2)} ${state.unit}',
                      style: AppStyles.activetabStyle,
                    ),
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
                      borderRadius:
                          BorderRadius.circular(DEFAULT_BORDER_RADIUS),
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
                            _getMapModeAvatar(_mapMode),
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
                CustomButton(
                  btnTxt: 'Get Directions',
                  onTap: () {
                    widget.mapBloc
                        .add(LaunchGoogleMaps(destination: widget.destination));
                  },
                ),
              ],
            ),
          );
        }

        if (state is CalculateDistanceInMetersLoading) {
          return Shimmer.fromColors(
            baseColor: AppColors.darkGray,
            highlightColor: AppColors.lightGray,
            child: Container(
              height: MediaQuery.of(context).size.height * .3,
              width: double.maxFinite,
            ),
          );
        }
        return Container();
      },
    );
  }

  String _getMapModeAvatar(MapMode mapMode) {
    switch (mapMode) {
      case MapMode.WALKING:
        return AppImages.walkIcon;
      case MapMode.CYCLE:
        return AppImages.cycleIcon;
      case MapMode.TWO_WHEELER:
        return AppImages.motercycleIcon;
    }
  }

  MapMode _getMapMode(double distance, String unit) {
    if (unit == 'Meters') {
      return MapMode.WALKING;
    }
    if (distance > 2) {
      return MapMode.CYCLE;
    }
    return MapMode.TWO_WHEELER;
  }
}
