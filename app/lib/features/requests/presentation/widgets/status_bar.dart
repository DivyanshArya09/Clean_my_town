import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/app_images.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DragableBar extends StatefulWidget {
  final double? height;
  const DragableBar({super.key, this.height});

  @override
  State<DragableBar> createState() => _DragableBarState();
}

class _DragableBarState extends State<DragableBar> {
  double sliderValue = 0.3;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: widget.height ?? MediaQuery.of(context).size.height * 0.2,
          child: Stack(
            children: [
              Slider(
                activeColor: AppColors.primary,
                value: sliderValue,
                onChanged: (v) {
                  setState(() {
                    sliderValue = v;
                  });
                },
                min: 0,
                max: .85,
              ),
              Positioned(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        _getImageAsPerProgress(sliderValue),
                        height: 50.h,
                      ),
                      CustomSpacers.height16,
                      Text(
                        calculatePercentage(sliderValue).toString() + '%',
                        style: AppStyles.roboto_14_500_dark,
                      ),
                    ],
                  ),
                ),
                top: 12,
                left: sliderValue > .8
                    ? MediaQuery.of(context).size.width * sliderValue - 64.w
                    : MediaQuery.of(context).size.width * sliderValue - 32.w,
              )
            ],
          ),
        ),
      ],
    );
  }

  String _getImageAsPerProgress(double value) {
    if (value >= 0 && value < .1) {
      return AppImages.pendingWork;
    } else if (value <= .8) {
      return AppImages.inProgressWork;
    } else {
      return AppImages.workDone;
    }
  }

  int calculatePercentage(double value) {
    if (value < 0 || value > 8.5) {
      return 0;
    } else {
      return ((value / 8.5) * 100).round() * 10;
    }
  }
}
