import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/app_images.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/core/utils/toast_utils.dart';
import 'package:app/features/requests/presentation/blocs/request_bloc/request_bloc.dart';
import 'package:app/features/requests/presentation/models/request_model.dart';
import 'package:app/ui/custom_button.dart';
import 'package:app/ui/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditRequestBottomSheet extends StatefulWidget {
  final RequestModel requestModel;
  final RequestBloc requestBloc;
  const EditRequestBottomSheet(
      {super.key, required this.requestModel, required this.requestBloc});

  @override
  State<EditRequestBottomSheet> createState() => _EditRequestBottomSheetState();
}

class _EditRequestBottomSheetState extends State<EditRequestBottomSheet> {
  late TextEditingController _titleTC, _locationTC, _descriptionTC;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _titleTC = TextEditingController(text: widget.requestModel.title);
    _locationTC = TextEditingController(text: widget.requestModel.fullAddress);
    _descriptionTC =
        TextEditingController(text: widget.requestModel.description);
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    _titleTC.dispose();
    _locationTC.dispose();
    _descriptionTC.dispose();
    if (_formKey.currentState != null) {
      _formKey.currentState!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestBloc, RequestState>(
      listener: (context, state) {
        if (state is UpdateRequestSuccess) {
          Navigator.pop(context);
        }

        if (state is UpdateRequestFailed) {
          ToastHelpers.showToast(state.message);
        }
      },
      bloc: widget.requestBloc,
      buildWhen: (previous, current) =>
          current is UpdateRequestSuccess ||
          current is UpdateRequestFailed ||
          current is UpdateRequestLoading,
      builder: (context, state) {
        if (state is UpdateRequestLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(
                left: DEFAULT_Horizontal_PADDING,
                right: DEFAULT_Horizontal_PADDING,
                top: DEFAULT_VERTICAL_PADDING,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Edit Request',
                            style: AppStyles.roboto_16_400_dark),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close, size: 20),
                        )
                      ],
                    ),
                    CustomSpacers.height10,
                    Text(
                      'Title',
                      style: AppStyles.inActivetabStyle,
                    ),
                    CustomSpacers.height10,
                    CustomTextField(
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return "Title can't be empty";
                        }
                        return null;
                      },
                      controller: _titleTC,
                      hint: "Add title",
                    ),
                    CustomSpacers.height10,
                    Text(
                      'Location',
                      style: AppStyles.inActivetabStyle,
                    ),
                    CustomSpacers.height10,
                    CustomTextField(
                      controller: _locationTC,
                      hint: "Location",
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return "Location can't be empty";
                        }
                        return null;
                      },
                      suffix: SizedBox(
                        height: 20.h,
                        child: Image.asset(
                          AppImages.mapIcon,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    CustomSpacers.height10,
                    Text(
                      'Description',
                      style: AppStyles.inActivetabStyle,
                    ),
                    CustomSpacers.height10,
                    CustomTextField(
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return "Description can't be empty";
                        }
                        return null;
                      },
                      controller: _descriptionTC,
                      hint:
                          "Add description/or equipments you need for this request",
                      maxLines: 5,
                    ),
                    CustomSpacers.height40,
                    CustomButton(
                      btnTxt: 'Update',
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          // Navigator.pop(context);
                          RequestUpdateEntity requestUpdateEntity =
                              RequestUpdateEntity(
                            title: _titleTC.text,
                            fullAddress: _locationTC.text,
                            description: _descriptionTC.text,
                          );

                          widget.requestBloc.add(
                            UpdateRequestEvent(
                              docId: widget.requestModel.docId!,
                              entity: requestUpdateEntity,
                            ),
                          );
                        }
                      },
                    ),
                    CustomSpacers.height40,
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/*
Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DEFAULT_Horizontal_PADDING,
              vertical: DEFAULT_VERTICAL_PADDING,
            ),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              border: Border(
                top: BorderSide(
                  color: AppColors.primary,
                  width: 1,
                ),
              ),
            ),
            child: CustomButton(
              btnTxt: 'Update',
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  // Navigator.pop(context);
                }
              },
            ),
          ),
        )

 */
