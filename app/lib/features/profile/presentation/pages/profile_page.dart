import 'dart:async';
import 'dart:io';

import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/core/utils/string_formatter.dart';
import 'package:app/core/utils/toast_utils.dart';
import 'package:app/features/home/models/user_model.dart';
import 'package:app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:app/features/profile/presentation/model/profile_model.dart';
import 'package:app/features/profile/presentation/widgets/logout_dialog.dart';
import 'package:app/features/profile/widgets/profile_tile.dart';
import 'package:app/route/app_pages.dart';
import 'package:app/route/custom_navigator.dart';
import 'package:app/ui/custom_button.dart';
import 'package:app/ui/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

enum UserActionType { PickImage, EditProfile }

enum SheetType { UpdateName, UpdateNumber }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? image;
  late TextEditingController _nameTC;
  late TextEditingController _numberTC;
  late ProfileBloc _refBloc;
  UserModel user = UserModel.empty();
  ProfileModel profile = ProfileModel.empty();
  final StreamController<ProfileModel> _streamController =
      StreamController<ProfileModel>.broadcast();
  final StreamController<String> _nameStream =
      StreamController<String>.broadcast();
  bool canPop = true;
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _nameTC = TextEditingController();
    _numberTC = TextEditingController();
    _refBloc = ProfileBloc(context: context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refBloc.add(GetUserEvent());
    });
    super.initState();
  }

  @override
  void dispose() {
    _refBloc.close();
    _nameStream.close();
    _numberTC.dispose();
    _nameTC.dispose();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        bloc: _refBloc,
        listener: (context, state) {
          if (state is ImagePickerSuccessState) {
            // _streamController.add(state.image);
            image = state.image;
            profile = profile.copyWith(image: image, isChanged: true);

            _streamController.add(profile);
          }
          if (state is ImagePickerError) {
            ToastHelpers.showToast(state.message);
          }

          if (state is ProfileError) {
            Navigator.pop(context);
            ToastHelpers.showToast(state.message);
          }

          if (state is ProfileSuccess) {
            Navigator.pop(context);
            _streamController.add(profile.copyWith(isChanged: false));
            _refBloc.add(GetUserEvent());
          }

          if (state is GetUserErrorState) {
            ToastHelpers.showToast(state.message);
          }

          if (state is ProfileLoading) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) => Material(
                type: MaterialType.transparency,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ), // Replace with your desired overlay content
                ),
              ),
            );
          }

          if (state is GetUserSuccessState) {
            user = state.user;
            profile = profile.copyWith(
              name: user.name,
              email: user.email,
              image: user.profilePicture,
              isChanged: false,
              number: user.number,
            );

            _streamController.add(profile);
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
          if (state is GetUserLoadingState) {
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
            ),
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomSpacers.height16,
                  StreamBuilder<ProfileModel>(
                    stream: _streamController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return _buildProfilePicture(snapshot.data!);
                      } else {
                        return _buildProfilePicture(profile);
                      }
                    },
                  ),
                  CustomSpacers.height16,
                  _buildProfileList(state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(50.h),
      child: StreamBuilder<ProfileModel>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AppBar(
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  !snapshot.data!.isChanged
                      ? Navigator.pop(context)
                      : showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text("Are you sure?"),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              title: Text(
                                "Do you want to Exit? Changes will be lost",
                                style: AppStyles.headingDark,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _refBloc.add(SaveProfile(
                                        profileModel: snapshot.data!));
                                  },
                                  child: Text(
                                    "Save Changes",
                                    style: AppStyles.activetabStyle,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    CustomNavigator.popUntilRoute(
                                        context, AppPages.home);
                                  },
                                  child: Text(
                                    "Yes",
                                    style: AppStyles.activetabStyle,
                                  ),
                                ),
                              ],
                            );
                          });
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.black,
                ),
              ),
              actions: snapshot.data!.isChanged
                  ? [
                      TextButton(
                        onPressed: () {
                          _refBloc
                              .add(SaveProfile(profileModel: snapshot.data!));
                        },
                        child: Text(
                          'Save Changes',
                          style: AppStyles.activetabStyle,
                        ),
                      )
                    ]
                  : [],
              title: const Text('Profile'),
            );
          }
          return AppBar(
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
          );
        },
      ),
    );
  }

  _buildProfilePicture(
    ProfileModel user,
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
                child: _buildImageWidget(context, user.image),
              ),
              Positioned(
                bottom: -7,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showBottomSheet(UserActionType.PickImage),
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
        Text(user.name, style: AppStyles.roboto_16_500_dark),
        Text(user.email, style: AppStyles.roboto_16_400_dark),
        Text(
          user.number!.isEmpty ? "No Contact Details" : user.number!,
          style: AppStyles.roboto_16_400_dark,
        ),
      ],
    );
  }

  Widget _buildImageWidget(BuildContext context, dynamic data) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        onTap: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: data is File
                ? Image.file(
                    data,
                    fit: BoxFit.scaleDown,
                  )
                : Image.network(
                    data as String,
                    fit: BoxFit.scaleDown,
                  ),
          ),
        ),
        child: data is File
            ? Image.file(
                data,
                fit: BoxFit.scaleDown,
              )
            : data is String && data.isNotEmpty
                ? Image.network(
                    data,
                    fit: BoxFit.scaleDown,
                  )
                : Icon(
                    Icons.person,
                    size: 90,
                    color: AppColors.white,
                  ),
      ),
    );
  }

  _buildProfileList(ProfileState state) {
    return Column(
      children: [
        CustomButton(
          btnWidth: 200.w,
          btnRadius: 50,
          btnTxt: 'Edit Profile',
          onTap: () => _showBottomSheet(UserActionType.EditProfile),
        ),
        CustomSpacers.height40,
        ProfileTile(
          leading: Icon(
            Icons.call,
            color: AppColors.primary,
          ),
          title: 'Settings',
          onTap: () {},
        ),
        ProfileTile(
          leading: Icon(
            Icons.notifications,
            color: AppColors.primary,
          ),
          title: 'Notifications',
          onTap: () {},
        ),
        ProfileTile(
          leading: Icon(
            Icons.language,
            color: AppColors.primary,
          ),
          title: 'Language',
          onTap: () {},
        ),
        ProfileTile(
          leading: Icon(
            Icons.help,
            color: AppColors.primary,
          ),
          title: 'Help',
          onTap: () {},
        ),
        CustomSpacers.height32,
        ProfileTile(
          leading: Icon(
            Icons.logout,
            color: AppColors.primary,
          ),
          title: 'Logout',
          onTap: () =>
              showDialog(context: context, builder: (_) => LogOutDialog()),
          disableTrailing: true,
        ),
      ],
    );
  }

  // =======================DIALOG'S========================
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
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              _streamController
                  .add(profile.copyWith(image: '', isChanged: true));
            },
            child: Text(
              'Remove',
              style: AppStyles.activetabStyle,
            ),
          )
        ],
      ),
    );
  }

  // ========================BOTTOM SHEET'S========================
  _showBottomSheet(UserActionType type) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              CustomSpacers.height16,
              if (type == UserActionType.EditProfile) ...[
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _changeNameBottomSheet(SheetType.UpdateName);
                  },
                  leading: Icon(
                    Icons.edit,
                  ),
                  title: Text('Change name'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.contact_page,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _changeNameBottomSheet(SheetType.UpdateNumber);
                  },
                  title: Text(
                    user.number == null || user.number!.isEmpty
                        ? 'Add Contact Number'
                        : 'Update Contact Number',
                  ),
                ),
                ListTile(
                  onTap: () => _showDialog(),
                  leading: Icon(
                    Icons.delete,
                  ),
                  title: Text('Remove profile picture'),
                ),
                CustomSpacers.height16,
              ],
              if (type == UserActionType.PickImage) ...[
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

  _changeNameBottomSheet(SheetType type) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                left: DEFAULT_Horizontal_PADDING,
                right: DEFAULT_Horizontal_PADDING,
                top: DEFAULT_VERTICAL_PADDING,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    type == SheetType.UpdateName ? 'Change Name' : 'Add Number',
                    style: AppStyles.headingDark,
                  ),
                  CustomSpacers.height34,
                  type == SheetType.UpdateName
                      ? CustomTextField(
                          hint: 'Enter your name',
                          controller: _nameTC,
                          onChanged: (value) {
                            _nameStream.add(value);
                          },
                        )
                      : CustomTextField(
                          keyboardType: TextInputType.number,
                          hint: 'Enter your Number',
                          validator: (p0) {
                            if (p0!.isEmpty || p0.length < 10) {
                              return 'Please enter your number';
                            }
                            return null;
                          },
                          controller: _numberTC,
                          onChanged: (value) {
                            _nameStream.add(value);
                          },
                        ),
                  CustomSpacers.height34,
                  StreamBuilder<String>(
                      stream: _nameStream.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: CustomButton(
                              btnTxt: 'Update',
                              onTap: () {
                                Navigator.pop(context);
                                if (type == SheetType.UpdateName) {
                                  _streamController.add(
                                    profile.copyWith(
                                        isChanged: true,
                                        name: _nameTC.text
                                            .capitalizeFirstLetterOfEachWord()),
                                  );
                                } else {
                                  if (_formKey.currentState!.validate()) {
                                    _streamController.add(
                                      profile.copyWith(
                                          isChanged: true,
                                          number: _numberTC.text),
                                    );
                                  }
                                }
                              },
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                  CustomSpacers.height34,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
