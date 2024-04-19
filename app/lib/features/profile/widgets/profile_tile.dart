import 'package:app/core/styles/app_styles.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class ProfileTile extends StatelessWidget {
  final Icon leading;
  final String title;
  final VoidCallback onTap;
  final bool? disableTrailing;
  const ProfileTile({
    super.key,
    this.disableTrailing = false,
    required this.leading,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withOpacity(.3),
        ),
        child: leading,
      ),
      title: Text(title, style: AppStyles.roboto_14_500_dark),
      trailing: disableTrailing!
          ? null
          : Container(
              height: 30,
              width: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(.1),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primary.withOpacity(.8),
                size: 16,
              ),
            ),
    );
  }
}
