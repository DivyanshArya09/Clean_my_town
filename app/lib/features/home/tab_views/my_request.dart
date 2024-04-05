import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/app_images.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/features/add_request/model/request_model.dart';
import 'package:app/features/add_request/presentation/bloc/bloc/request_bloc.dart';
import 'package:app/features/add_request/presentation/models/location_model.dart';
import 'package:app/features/add_request/presentation/pages/request_detail_page.dart';
import 'package:app/features/home/widgets/request_tile.dart';
import 'package:app/features/shared/loading_page.dart';
import 'package:app/route/app_pages.dart';
import 'package:app/route/custom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyRequests extends StatefulWidget {
  final LocationModel location;
  const MyRequests({super.key, required this.location});

  @override
  State<MyRequests> createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests>
    with AutomaticKeepAliveClientMixin {
  final _reqRefBloc = RequestBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reqRefBloc.add(GetMyRequestEvent());
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<RequestBloc, RequestState>(
      bloc: _reqRefBloc,
      builder: (context, state) {
        if (state is MyRequestEmpty) {
          return _buildEmptyBody();
        }

        if (state is MyRequestLoading) {
          return const LoadingScreen();
        }

        if (state is MyRequestSuccess) {
          return _buildRequestBody(state.requestModel);
        }

        if (state is MYRequestError) {
          return Center(
            child: Text(state.error),
          );
        }
        return Center(
          child: Text(state.toString()),
        );
      },
    );
  }

  _buildRequestBody(List<RequestModel> requests) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: double.maxFinite,
      width: double.maxFinite,
      color: AppColors.lightGray,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildList(requests),
              CustomSpacers.height16,
            ],
          ),
          _buildcustomFloatingButton(),
        ],
      ),
    );
  }

  _buildList(List<RequestModel> requests) {
    return Expanded(
      child: ListView.separated(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: index == 0 ? 24 : 0),
            child: RequestTile(
              request: requests[index],
              onTap: () => CustomNavigator.pushTo(
                context,
                AppPages.requestDetailPage,
                arguments: {
                  'request': requests[index],
                  'requestType': RequestType.myRequest,
                },
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return CustomSpacers.height12;
        },
      ),
    );
  }

  _buildEmptyBody() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      height: double.maxFinite,
      width: double.maxFinite,
      color: AppColors.lightGray,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'There is no requests yet.\n Add one By tapping "+".',
                textAlign: TextAlign.center,
                style: AppStyles.titleStyle,
              ),
              SvgPicture.asset(
                AppImages.volunteers,
                height: MediaQuery.of(context).size.height * 0.5,
              ),
              CustomSpacers.height16,
            ],
          ),
          _buildcustomFloatingButton(),
        ],
      ),
    );
  }

  Widget _buildcustomFloatingButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: InkWell(
        onTap: () {
          CustomNavigator.pushTo(context, AppPages.addRequests,
              arguments: widget.location);
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                offset: const Offset(0, 5),
                color: AppColors.black.withOpacity(0.5),
              ),
            ],
          ),
          height: 50.w,
          width: 50.w,
          child: Icon(
            Icons.add,
            color: AppColors.white,
            size: 30.w,
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
