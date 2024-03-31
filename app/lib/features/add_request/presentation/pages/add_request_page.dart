import 'dart:io';

import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/managers/location_manager.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/core/utils/toast_utils.dart';
import 'package:app/features/add_request/model/request_model.dart';
import 'package:app/features/add_request/presentation/bloc/bloc/request_bloc.dart';
import 'package:app/features/add_request/presentation/bloc/geolocator_bloc.dart';
import 'package:app/features/add_request/presentation/models/location_model.dart';
import 'package:app/route/custom_navigator.dart';
import 'package:app/ui/custom_button.dart';
import 'package:app/ui/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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
  var _formKey = GlobalKey<FormState>();
  RequestModel reqModel = RequestModel.empty();

  File? image;
  String town = '';

  @override
  void initState() {
    _titleTC = TextEditingController();
    _locationTC = TextEditingController();
    _descriptionTC = TextEditingController();
    _locationTC.text =
        "${widget.location.address.state}, ${widget.location.address.town}, ${widget.location.address.road}, ${widget.location.address.postcode}";
    LocationManager.getLocation().then((value) => {
          _geolocatorRefBloc.add(GetLocation(
            lat: value.latitude,
            long: value.longitude,
          )),
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Request'),
        centerTitle: true,
      ),
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
                  CustomNavigator.pop(context);
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

                // CustomNavigator.pop(context);
              },
            )
          ],
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: DEFAULT_Horizontal_PADDING,
                    vertical: DEFAULT_VERTICAL_PADDING),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      CustomSpacers.height16,
                      InkWell(
                        onTap: () {
                          ToastHelpers.showToast("Read only");
                        },
                        child: CustomTextField(
                          disabled: true,
                          controller: _locationTC,
                          hint: "Location",
                          suffix: const Icon(Icons.location_city,
                              color: Colors.grey),
                        ),
                      ),
                      CustomSpacers.height10,
                      Text(
                        'Optional*',
                        style: AppStyles.inActivetabStyle,
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
                        onTap: () => pickImage(),
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Add image',
                            style: AppStyles.activetabStyle,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * .4,
                        child: image == null
                            ? const Text('No image')
                            : Image.file(
                                image!,
                                fit: BoxFit.cover,
                              ),
                      ),
                      CustomSpacers.height80,
                    ],
                  ),
                ),
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
                        reqModel = reqModel.copyWith(
                          title: _titleTC.text,
                          description: _descriptionTC.text,
                          location:
                              "${widget.location.lat.toString()}-${widget.location.lon.toString()}",
                          image: image!.path,
                          town: town,
                          status: true,
                        );

                        print('------------------->${reqModel}');

                        _requestRefBloc.add(AddRequest(
                            requestModel: reqModel, imagePath: image!));
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        this.image = File(image.path);
      });
    }
  }
}
