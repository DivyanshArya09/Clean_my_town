import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/app_images.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/ui/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.black,
          ),
        ),
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
            horizontal: DEFAULT_Horizontal_PADDING,
            vertical: DEFAULT_VERTICAL_PADDING),
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomSpacers.height16,
              _buildProfilePicture(),
              CustomSpacers.height16,
              _buildProfileList(),
            ],
          ),
        ),
      ),
    );
  }

  _buildProfilePicture() {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 120.h,
          width: 120.h,
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.darkGray,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  AppImages.volunteers,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                bottom: -7,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showBottomSheet(),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    height: 30.h,
                    width: 30.h,
                    child: Icon(
                      size: 15,
                      Icons.add_a_photo,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        CustomSpacers.height12,
        Text('John Doe', style: AppStyles.roboto_16_500_dark),
        Text('5qoZT@example.com', style: AppStyles.roboto_16_400_dark),
      ],
    );
  }

  _buildProfileList() {
    return Column(
      children: [
        CustomButton(
          btnWidth: 200.w,
          btnRadius: 50,
          btnTxt: 'Edit Profile',
          onTap: () {},
        ),
        CustomSpacers.height40,
        _buildProfileTile(
            Icon(
              Icons.settings,
              color: AppColors.primary,
            ),
            'Settings'),
        _buildProfileTile(
            Icon(
              Icons.notifications,
              color: AppColors.primary,
            ),
            'Notifications'),
        _buildProfileTile(
            Icon(
              Icons.language,
              color: AppColors.primary,
            ),
            'Language'),
        _buildProfileTile(
            Icon(
              Icons.help,
              color: AppColors.primary,
            ),
            'Help'),
        CustomSpacers.height32,
        _buildProfileTile(
            Icon(
              Icons.logout,
              color: AppColors.primary,
            ),
            'Logout',
            disableTrailing: true),
      ],
    );
  }

  _buildProfileTile(Icon leading, String title,
      {bool disableTrailing = false}) {
    return ListTile(
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
      trailing: disableTrailing
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

  _showBottomSheet() {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              CustomSpacers.height16,
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                ),
                title: Text('Camera'),
              ),
              ListTile(
                leading: Icon(
                  Icons.image,
                ),
                title: Text('Gallery'),
              ),
            ],
          ),
        );
      },
    );
  }
}
