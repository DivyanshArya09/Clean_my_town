import 'dart:async';

import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/enums/request_enums.dart';
import 'package:app/core/helpers/notification_helper/notification_helper.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/features/home/presentation/blocs/open_request_bloc/open_req_bloc.dart';
import 'package:app/features/requests/presentation/blocs/contact_bloc/contact_bloc.dart';
import 'package:app/features/requests/presentation/blocs/map_bloc/map_bloc.dart';
import 'package:app/features/requests/presentation/blocs/request_bloc/request_bloc.dart';
import 'package:app/features/requests/presentation/models/request_model.dart';
import 'package:app/features/requests/presentation/widgets/animated_text.dart';
import 'package:app/features/requests/presentation/widgets/contact_details_card.dart';
import 'package:app/features/requests/presentation/widgets/distance_card.dart';
import 'package:app/features/requests/presentation/widgets/edit_request_bottom_sheet.dart';
import 'package:app/features/requests/presentation/widgets/status_card.dart';
import 'package:app/injection_container.dart';
import 'package:app/ui/custom_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class OthersRequestDetailPage extends StatefulWidget {
  RequestModel requestModel;
  final RequestType? requestType;
  final RequestBloc? requestBloc;
  final OpenReqBloc? openReqBloc;
  OthersRequestDetailPage(
      {super.key,
      required this.requestModel,
      this.requestType,
      this.openReqBloc,
      this.requestBloc});

  @override
  State<OthersRequestDetailPage> createState() =>
      _OthersRequestDetailPageState();
}

class _OthersRequestDetailPageState extends State<OthersRequestDetailPage> {
  late DraggableScrollableController _sheetController;
  late StreamController<double> _sheetStreamController;
  late MapBloc _mapBloc;
  late ContactBloc _contactBloc;

  @override
  void initState() {
    _sheetController = DraggableScrollableController();
    _sheetStreamController = StreamController<double>.broadcast();
    _mapBloc = MapBloc();
    _contactBloc = ContactBloc();
    _sheetController.addListener(
      () {
        _sheetStreamController.add(_sheetController.size);
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _sheetStreamController.add(.2);
      _contactBloc.add(
        GetContactDetailsEvent(
          widget.requestModel.user,
        ),
      );

      _mapBloc.add(CalculateDistanceInKM(
        destination: widget.requestModel.coordinates,
      ));
    });
    super.initState();
  }

  @override
  void dispose() {
    _sheetStreamController.close();
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.requestType == RequestType.my
          ? _buildDetailPage(widget.requestModel)
          : BlocBuilder<OpenReqBloc, OpenReqState>(
              buildWhen: (previous, current) => current is OpenReqLoaded,
              bloc: sl.get<OpenReqBloc>(),
              builder: (context, state) {
                print('--======================<  I am here');
                return _buildDetailPage(
                  (state as OpenReqLoaded)
                      .requests
                      .where((element) =>
                          element.docId == widget.requestModel.docId)
                      .first,
                );
              },
            ),
    );
  }

  _buildDetailPage(RequestModel requestModel) {
    return Stack(
      children: [
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: requestModel.image,
            fit: BoxFit.fitHeight,
            errorWidget: (context, url, error) {
              return const Icon(Icons.error);
            },
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
        Positioned(
          top: 50.h,
          left: 16.h,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSpacers.height12,
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    requestModel.title,
                    style: AppStyles.heading2Light,
                  ),
                ),
                CustomSpacers.height12,
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, color: AppColors.err),
                    CustomSpacers.width8,
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        softWrap: true,
                        textAlign: TextAlign.start,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        requestModel.fullAddress,
                        style: AppStyles.roboto_14_500_light,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: AppColors.white,
            ),
          ),
          right: 10,
          top: 20.h,
        ),
        DraggableScrollableSheet(
          expand: true,
          snap: true,
          controller: _sheetController,
          initialChildSize: .17,
          minChildSize: .17,
          // initialChildSize: .2,
          builder: (context, scrollController) {
            return DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(DEFAULT_BORDER_RADIUS),
                  topRight: Radius.circular(DEFAULT_BORDER_RADIUS),
                ),
              ),
              child: StreamBuilder<double>(
                  stream: _sheetStreamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Stack(
                        children: [
                          SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              horizontal: DEFAULT_Horizontal_PADDING,
                              vertical: DEFAULT_VERTICAL_PADDING,
                            ),
                            controller: scrollController,
                            child: Column(
                              children: [
                                if (snapshot.data == null ||
                                    snapshot.data! < .9) ...[
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightGray,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.keyboard_arrow_up,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  CustomSpacers.height12,
                                  AnimateText(
                                    text: "Swipe up to see details",
                                  ),
                                ] else ...[
                                  CustomSpacers.height21,
                                  Text(
                                    "Details",
                                    style: AppStyles.roboto_16_400_dark,
                                  ),
                                  CustomSpacers.height12,
                                  _buildBody(requestModel),
                                ],
                              ],
                            ),
                          ),
                          Visibility(
                            visible: snapshot.data! > .9,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                color: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: DEFAULT_VERTICAL_PADDING,
                                    horizontal: 16),
                                child: CustomButton(
                                  // btnType: ButtonType.secondary,
                                  btnTxt:
                                      widget.requestType == RequestType.others
                                          ? 'Accept'
                                          : "Edit Request",
                                  onTap: () {
                                    if (widget.requestType ==
                                        RequestType.others) {
                                      print('==============> button pressed');
                                      NotificationHelper.postNotification(
                                        "Hello I acceped you request",
                                        "I am comming as soon as possible",
                                        requestModel.token,
                                      );
                                    }
                                    if (widget.requestType == RequestType.my) {
                                      return _showEditBottomSheet();
                                    }
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    }
                    return Container();
                  }),
            );
          },
        ),
      ],
    );
  }

  _buildBody(RequestModel requestModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * .4,
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.lightGray,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: requestModel.image,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) {
                return const Icon(Icons.error);
              },
            ),
          ),
        ),
        CustomSpacers.height12,
        if (widget.requestType == RequestType.others) ...[
          Text(
            'Distance',
            style: AppStyles.roboto_16_400_dark,
          ),
          CustomSpacers.height12,
          DistanceCard(
            destination: requestModel.coordinates,
            mapBloc: _mapBloc,
          ),
        ],
        if (widget.requestType == RequestType.my) ...[
          Text(
            'Status',
            style: AppStyles.roboto_16_400_dark,
          ),
          CustomSpacers.height12,
          StatusCard(),
        ],
        CustomSpacers.height12,
        Text(
          'Details',
          style: AppStyles.roboto_16_400_dark,
        ),
        CustomSpacers.height12,
        SizedBox(
          width: MediaQuery.of(context).size.width * .9,
          child: Text(
            requestModel.description,
            softWrap: true,
            textAlign: TextAlign.start,
            style: AppStyles.roboto_14_400_dark,
          ),
        ),
        CustomSpacers.height12,
        Text(
          'Contact Details',
          style: AppStyles.roboto_16_400_dark,
        ),
        CustomSpacers.height12,
        _buildContactDetails(requestModel),
        CustomSpacers.height40,
        CustomSpacers.height40,
      ],
    );
  }

  _buildContactDetails(RequestModel requestModel) {
    return BlocBuilder<ContactBloc, ContactState>(
      bloc: _contactBloc,
      buildWhen: (previous, current) =>
          current is GetContactDetailsSuccess ||
          current is GetContactDetailsError ||
          current is GetContactDetailsLoading,
      builder: (context, state) {
        if (state is GetContactDetailsSuccess) {
          return ContactDetailsCard(
            requestType: widget.requestType!,
            user: state.userModel,
            requestDate: requestModel.dateTime,
          );
        }
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * .3,
          ),
        );
      },
    );
  }

  _showEditBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => EditRequestBottomSheet(
        requestModel: widget.requestModel,
        requestBloc: widget.requestBloc!,
        onEdit: (requestModel) {
          if (requestModel != null) {
            widget.requestModel = requestModel;
            setState(() {});
          }
        },
      ),
    );
  }
}
