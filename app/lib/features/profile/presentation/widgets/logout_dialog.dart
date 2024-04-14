import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/helpers/user_helpers/user_helper.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/features/auth/presentation/pages/login_page.dart';
import 'package:app/ui/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogOutDialog extends StatelessWidget {
  const LogOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.logout_outlined,
            color: AppColors.primary,
            size: 60.h,
          ),
          CustomSpacers.height12,
          Text(
            'Oh no! You\'re Leaving....',
            style: AppStyles.headingDark,
          ),
          CustomSpacers.height10,
          Text(
            'Are you sure you want to log out?',
            style: AppStyles.roboto_16_400_dark,
          ),
          CustomSpacers.height20,
          CustomButton(
            btnTxt: 'Nah, Just Kidding',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          CustomSpacers.height12,
          CustomButton(
            btnType: ButtonType.secondary,
            btnTxt: 'Yes, Log me out',
            onTap: () async {
              await SharedPreferencesHelper.logOut().then(
                (value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage()),
                      (Route<dynamic> route) => false);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
