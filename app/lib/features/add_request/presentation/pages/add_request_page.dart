import 'dart:io';

import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/app_images.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/core/utils/toast_utils.dart';
import 'package:app/features/add_request/model/request_model.dart';
import 'package:app/features/add_request/presentation/bloc/bloc/request_bloc.dart';
import 'package:app/features/add_request/presentation/bloc/geolocator_bloc.dart';
import 'package:app/features/add_request/presentation/models/location_model.dart';
import 'package:app/route/app_pages.dart';
import 'package:app/route/custom_navigator.dart';
import 'package:app/ui/custom_button.dart';
import 'package:app/ui/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddRequestPage extends StatefulWidget {
  final LocationModel location;
  const AddRequestPage({super.key, required this.location});

  @override
  State<AddRequestPage> createState() => _AddRequestPageState();
}

class _AddRequestPageState extends State<AddRequestPage> {
  final _geolocatorRefBloc = GeolocatorBloc();
  final _requestRefBloc = RequestBloc();
  late TextEditingController _titleTC, _locationTC, _descriptionTC;
  late DraggableScrollableController _sheetController;
  var _formKey = GlobalKey<FormState>();
  RequestModel reqModel = RequestModel.empty();

  File? image;
  String town = '';

  @override
  void initState() {
    _titleTC = TextEditingController();
    _locationTC = TextEditingController();
    _sheetController = DraggableScrollableController();
    _descriptionTC = TextEditingController();
    _locationTC.text = widget.location.displayName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => _geolocatorRefBloc),
          BlocProvider(create: (_) => _requestRefBloc),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<GeolocatorBloc, GeolocatorState>(
              listener: (context, state) {
                if (state is GeolocatorError) {
                  ToastHelpers.showToast(state.error);
                } else if (state is GeolocatorSuccess) {
                  town = state.locationModel.address.town;
                }
              },
            ),
            BlocListener<RequestBloc, RequestState>(
              listener: (context, state) {
                if (state is RequestError) {
                  ToastHelpers.showToast(state.error);
                }
                if (state is RequestSuccess) {
                  CustomNavigator.pushReplace(context, AppPages.home,
                      arguments: false);
                }

                if (state is RequestLoading) {
                  showDialog(
                    context: context,
                    barrierDismissible:
                        false, // Prevent user from dismissing dialog
                    builder: (context) => const AlertDialog(
                      backgroundColor: Colors.transparent,
                      content: Center(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                if (state is ImagePickerLoading) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          "Opening Camera....",
                          style: AppStyles.roboto_14_500_light,
                        ),
                      ),
                    );
                }
                if (state is ImagePickerSuccess) {
                  image = state.imagePath;
                }
                if (state is ImagePickerError) {
                  ToastHelpers.showToast(state.error);
                }
              },
            )
          ],
          child: BlocBuilder<RequestBloc, RequestState>(
            bloc: _requestRefBloc,
            builder: (context, state) {
              return Stack(
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: AppColors.lightGray,
                          alignment: Alignment.topCenter,
                          height: MediaQuery.of(context).size.height,
                          child: image == null
                              ? GestureDetector(
                                  onTap: () =>
                                      _requestRefBloc.add(PickImageEvent()),
                                  child: SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height * .2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_a_photo,
                                          color: AppColors.darkGray,
                                          size: 30,
                                        ),
                                        CustomSpacers.height12,
                                        Text('Tap to add image',
                                            style: AppStyles.roboto_14_500_dark)
                                      ],
                                    ),
                                  ),
                                )
                              : Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) =>
                            DraggableScrollableSheet(
                          expand: true,
                          snap: true,
                          controller: _sheetController,
                          maxChildSize: 1,
                          minChildSize: .2,
                          initialChildSize: image != null ? .5 : .8,
                          snapSizes: [150 / constraints.maxHeight, 0.5, 0.8],
                          builder: (context, scrollController) {
                            return DecoratedBox(
                              decoration: const BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              child: CustomScrollView(
                                controller: scrollController,
                                physics: ClampingScrollPhysics(),
                                slivers: [
                                  SliverPadding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: DEFAULT_Horizontal_PADDING,
                                      vertical: DEFAULT_VERTICAL_PADDING,
                                    ),
                                    sliver: SliverList(
                                      delegate: SliverChildListDelegate.fixed(
                                        [
                                          Form(
                                            key: _formKey,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomTextField(
                                                  validator: (p0) {
                                                    if (p0 == null ||
                                                        p0.isEmpty) {
                                                      return "Title can't be empty";
                                                    }
                                                    return null;
                                                  },
                                                  controller: _titleTC,
                                                  hint: "Add title",
                                                ),
                                                CustomSpacers.height16,
                                                InkWell(
                                                  onTap: () {
                                                    ToastHelpers.showToast(
                                                        "Read only");
                                                  },
                                                  child: CustomTextField(
                                                    disabled: true,
                                                    controller: _locationTC,
                                                    hint: "Location",
                                                    suffix: SizedBox(
                                                      height: 20.h,
                                                      child: Image.asset(
                                                        AppImages.mapIcon,
                                                        fit: BoxFit.fitHeight,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                CustomSpacers.height10,
                                                Text(
                                                  'Optional*',
                                                  style: AppStyles
                                                      .inActivetabStyle,
                                                ),
                                                CustomSpacers.height10,
                                                CustomTextField(
                                                  controller: _descriptionTC,
                                                  hint:
                                                      "Add description/or equipments you need for this request",
                                                  maxLines: 5,
                                                ),
                                                CustomSpacers.height10,
                                                InkWell(
                                                  onTap: () {
                                                    _requestRefBloc
                                                        .add(PickImageEvent());
                                                  },
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text(
                                                      'Add image',
                                                      style: AppStyles
                                                          .activetabStyle,
                                                    ),
                                                  ),
                                                ),
                                                CustomSpacers.height80,
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: DEFAULT_Horizontal_PADDING,
                        vertical: 24,
                      ),
                      child: CustomButton(
                        btnTxt: 'Add Request',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            if (image == null) {
                              ToastHelpers.showToast("Please add image");
                            } else {
                              reqModel = reqModel.copyWith(
                                title: _titleTC.text,
                                description: _descriptionTC.text,
                                location:
                                    "${widget.location.lat.toString()}-${widget.location.lon.toString()}",
                                image: image!.path,
                                town: widget.location.address.stateDistrict,
                                status: true,
                              );
                              _requestRefBloc.add(AddRequest(
                                  requestModel: reqModel, imagePath: image!));
                            }
                          }
                        },
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
