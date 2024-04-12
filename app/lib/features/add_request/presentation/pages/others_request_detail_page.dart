import 'dart:async';

import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/features/add_request/model/request_model.dart';
import 'package:app/features/add_request/presentation/widgets/animated_text.dart';
import 'package:app/features/add_request/presentation/widgets/contact_details_card.dart';
import 'package:app/features/add_request/presentation/widgets/distance_card.dart';
import 'package:app/ui/custom_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OthersRequestDetailPage extends StatefulWidget {
  final RequestModel requestModel;
  const OthersRequestDetailPage({super.key, required this.requestModel});

  @override
  State<OthersRequestDetailPage> createState() =>
      _OthersRequestDetailPageState();
}

class _OthersRequestDetailPageState extends State<OthersRequestDetailPage> {
  late DraggableScrollableController _sheetController;
  late StreamController<double> _sheetStreamController;

  @override
  void initState() {
    _sheetController = DraggableScrollableController();
    _sheetStreamController = StreamController<double>.broadcast();
    _sheetController.addListener(
      () {
        _sheetStreamController.add(_sheetController.size);
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _sheetStreamController.add(.2);
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
      body: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: widget.requestModel.image,
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
                      widget.requestModel.title,
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
                          widget.requestModel.fullAddress,
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
                                        text: "Swipe up to see details"),
                                  ] else ...[
                                    CustomSpacers.height21,
                                    Text(
                                      "Details",
                                      style: AppStyles.roboto_16_400_dark,
                                    ),
                                    CustomSpacers.height12,
                                    _buildBody(),
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
                                    btnTxt: 'Accept',
                                    onTap: () {},
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
      ),
    );
  }

  _buildBody() {
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
              imageUrl: widget.requestModel.image,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) {
                return const Icon(Icons.error);
              },
            ),
          ),
        ),
        CustomSpacers.height12,
        Text(
          'Distance',
          style: AppStyles.roboto_16_400_dark,
        ),
        CustomSpacers.height12,
        DistanceCard(),
        CustomSpacers.height12,
        Text(
          'Details',
          style: AppStyles.roboto_16_400_dark,
        ),
        CustomSpacers.height12,
        SizedBox(
          width: MediaQuery.of(context).size.width * .9,
          child: Text(
            widget.requestModel.description,
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
        ContactDetailsCard(),
        CustomSpacers.height40,
        CustomSpacers.height40,
      ],
    );
  }
}
