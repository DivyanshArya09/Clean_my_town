import 'dart:async';
import 'dart:io';

import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/core/utils/toast_utils.dart';
import 'package:app/features/home/models/user_model.dart';
import 'package:app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:app/ui/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

enum SheetType { PickImage, EditProfile }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? image;
  final _refBloc = ProfileBloc();
  UserModel user = UserModel.empty();
  StreamController<dynamic> _streamController = StreamController<dynamic>();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refBloc.add(GetUserEvent());
    });
    super.initState();
  }

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
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                'Save Changes',
                style: AppStyles.activetabStyle,
              ))
        ],
        title: const Text('Profile'),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        bloc: _refBloc,
        listener: (context, state) {
          if (state is ImagePickerSuccessState) {
            _streamController.add(state.image);
            image = state.image;
          }
          if (state is ImagePickerError) {
            ToastHelpers.showToast(state.message);
          }

          if (state is ProfileError) {
            ToastHelpers.showToast(state.message);
          }

          if (state is ProfileSuccess) {
            ToastHelpers.showToast('Profile Updated....');
          }

          if (state is GetUserErrorState) {
            ToastHelpers.showToast(state.message);
          }

          if (state is GetUserSuccessState) {
            user = state.user;
            _streamController.add(state.user.profilePicture);
          }

          if (state is ImagePickerLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Loading...'),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading || state is GetUserLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is GetUserErrorState ||
              state is ImagePickerError ||
              state is ProfileError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          // if (state is GetUserSuccessState) {
          return SingleChildScrollView(
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
                  _buildProfilePicture(user.name, user.email),
                  CustomSpacers.height16,
                  _buildProfileList(state),
                ],
              ),
            ),
          );
          // }
          // return const Center(
          //   child: Text('Something went wrong'),
          // );
        },
      ),
    );
  }

  _buildProfilePicture(
    String? name,
    String? email,
  ) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 120.h,
          width: 120.h,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.darkGray,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: StreamBuilder(
                  stream: _streamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: InkWell(
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              contentPadding: EdgeInsets.zero,
                              content: snapshot.data is File
                                  ? Image.file(
                                      snapshot.data!,
                                      fit: BoxFit.fill,
                                    )
                                  : Image.network(
                                      snapshot.data as String,
                                    ),
                            ),
                          ),
                          child: snapshot.data is File
                              ? Image.file(
                                  snapshot.data!,
                                  fit: BoxFit.fill,
                                )
                              : (snapshot.data as String).isNotEmpty
                                  ? Image.network(
                                      snapshot.data as String,
                                    )
                                  : Icon(Icons.person,
                                      size: 60.h, color: AppColors.white),
                        ),
                      );
                    }
                    return Icon(Icons.person,
                        size: 60.h, color: AppColors.white);
                  },
                ),
              ),
              Positioned(
                bottom: -7,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showBottomSheet(SheetType.PickImage),
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
        Text(name ?? 'No Name', style: AppStyles.roboto_16_500_dark),
        Text(email!, style: AppStyles.roboto_16_400_dark),
      ],
    );
  }

  _buildProfileList(ProfileState state) {
    return Column(
      children: [
        CustomButton(
          btnWidth: 200.w,
          btnRadius: 50,
          btnTxt: image != null && state is! ProfileSuccess
              ? 'Save Profile'
              : 'Edit Profile',
          onTap: () {
            image != null && state is! ProfileSuccess
                ? _refBloc.add(SaveProfile(image: image!))
                : _showBottomSheet(SheetType.EditProfile);
          },
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

  _showDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        // contentPadding: EdgeInsets.zero,
        title: Text(
          'Are you sure you want to remove your profile picture?',
          style: AppStyles.roboto_16_500_dark,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppStyles.activetabStyle,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Remove',
              style: AppStyles.activetabStyle,
            ),
          )
        ],
      ),
    );
  }

  _showBottomSheet(SheetType type) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              CustomSpacers.height16,
              if (type == SheetType.EditProfile) ...[
                ListTile(
                  onTap: () {
                    // Navigator.pop(context);
                    // _refBloc.add(
                    //   PickImageEvent(
                    //     imageSource: ImageSource.camera,
                    //   ),
                    // );
                  },
                  leading: Icon(
                    Icons.edit,
                  ),
                  title: Text('Change name'),
                ),
                ListTile(
                  onTap: () => _showDialog(),
                  leading: Icon(
                    Icons.delete,
                  ),
                  title: Text('Remove profile picture'),
                ),
              ],
              if (type == SheetType.PickImage) ...[
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _refBloc.add(
                      PickImageEvent(
                        imageSource: ImageSource.camera,
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.camera_alt,
                  ),
                  title: Text('Camera'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _refBloc.add(
                      PickImageEvent(imageSource: ImageSource.gallery),
                    );
                  },
                  leading: Icon(
                    Icons.image,
                  ),
                  title: Text('Gallery'),
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}
