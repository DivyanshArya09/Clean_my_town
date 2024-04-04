import 'package:app/core/constants/app_images.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:flutter/material.dart';

class GettingLocationPage extends StatelessWidget {
  const GettingLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.maxFinite - 100,
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            child: Image.asset(
              AppImages.gettingLocation,
              fit: BoxFit.fitHeight,
            ),
          ),
          CustomSpacers.height24,
          Text(
            'Getting Location...',
            style: AppStyles.roboto_14_500_dark,
          ),
        ],
      ),
    );
  }
}
