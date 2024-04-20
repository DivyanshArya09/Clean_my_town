import 'dart:io';

import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/app_images.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/enums/request_enums.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/core/utils/date_time_formatter.dart';
import 'package:app/core/utils/toast_utils.dart';
import 'package:app/features/requests/presentation/add_request_utls.dart';
import 'package:app/features/requests/presentation/blocs/request_bloc/request_bloc.dart';
import 'package:app/features/requests/presentation/models/location_model.dart';
import 'package:app/features/requests/presentation/models/request_model.dart';
import 'package:app/features/shared/loading_page.dart';
import 'package:app/global_variables/global_varialbles.dart';
import 'package:app/ui/custom_button.dart';
import 'package:app/ui/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddRequestPage extends StatefulWidget {
  final LocationModel location;
  const AddRequestPage({
    super.key,
    required this.location,
  });

  @override
  State<AddRequestPage> createState() => _AddRequestPageState();
}

class _AddRequestPageState extends State<AddRequestPage> {
  final _requestRefBloc = RequestBloc();
  late TextEditingController _titleTC, _locationTC, _descriptionTC, _phoneTC;
  late DraggableScrollableController _sheetController;
  var _formKey = GlobalKey<FormState>();
  RequestModel reqModel = RequestModel.empty();

  File? image;

  @override
  void initState() {
    _titleTC = TextEditingController();
    _locationTC = TextEditingController();
    _sheetController = DraggableScrollableController();
    _descriptionTC = TextEditingController();
    _phoneTC = TextEditingController();
    _locationTC.text = widget.location.displayName;
    _phoneTC.text = USERMODEL.number ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _titleTC.dispose();
    _locationTC.dispose();
    _descriptionTC.dispose();
    _requestRefBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Request", style: AppStyles.appBarStyle),
        centerTitle: true,
      ),
      body: MultiBlocProvider(
        providers: [
          // BlocProvider(create: (_) => _geolocatorRefBloc),
          BlocProvider(create: (_) => _requestRefBloc),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<RequestBloc, RequestState>(
              listener: (context, state) {
                if (state is RequestError) {
                  ToastHelpers.showToast(state.error);
                }
                if (state is RequestSuccess) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  // CustomNavigator.pushReplace(context, AppPages.home,
                  //     arguments: false);
                }

                if (state is RequestLoading) {
                  showLoadingAlertDialog(context,
                      message: "Creating Request Please wait...");
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
                                                CustomTextField(
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
                                                CustomSpacers.height16,
                                                CustomTextField(
                                                  validator: (p0) {
                                                    if (p0 == null ||
                                                        p0.isEmpty) {
                                                      return "Contact number can't be empty";
                                                    }
                                                    return null;
                                                  },
                                                  controller: _phoneTC,
                                                  hint: "contact number",
                                                  suffix: SizedBox(
                                                    height: 20.h,
                                                    child: Icon(
                                                      Icons.phone,
                                                      color: AppColors.primary,
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
                        onTap: () => _handleOnAddRequestTap(),
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

  _handleOnAddRequestTap() {
    if (_formKey.currentState!.validate()) {
      String area = AddRequestUtils.getArea(
        widget.location.address,
      );
      if (area == '') {
        ToastHelpers.showToast("We are unable to determine your area");
      } else if (image == null) {
        ToastHelpers.showToast("Please add image");
      } else {
        reqModel = reqModel.copyWith(
          title: _titleTC.text,
          description: _descriptionTC.text,
          coordinates: Coordinates(
            lat: widget.location.lat,
            lon: widget.location.lon,
          ),
          number: _phoneTC.text,
          area: area,
          status: RequestStatus.pending,
          fullAddress: widget.location.displayName,
          dateTime: DateTime.now().toTime(),
        );
        _requestRefBloc
            .add(AddRequest(requestModel: reqModel, imagePath: image!));
      }
    }
  }
}
