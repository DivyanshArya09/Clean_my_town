import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/app_images.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAnimatedContainer extends StatefulWidget {
  final double height;

  const CustomAnimatedContainer({super.key, required this.height});
  @override
  _SizeChangingContainerState createState() => _SizeChangingContainerState();
}

class _SizeChangingContainerState extends State<CustomAnimatedContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 100.0, end: widget.height).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(50.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.err.withOpacity(.5),
          ),
          width: _animation.value.h,
          height: _animation.value.h,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.markerIcon,
                  // fit: BoxFit.cover,
                ),
                CustomSpacers.height10,
                Text(
                  textAlign: TextAlign.center,
                  "Getting your location...",
                  style: AppStyles.roboto_16_700_light,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
