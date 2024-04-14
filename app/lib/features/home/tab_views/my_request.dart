import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/app_images.dart';
import 'package:app/core/enums/request_enums.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/features/home/widgets/request_tile.dart';
import 'package:app/features/requests/presentation/blocs/request_bloc/request_bloc.dart';
import 'package:app/features/requests/presentation/models/location_model.dart';
import 'package:app/features/requests/presentation/models/request_model.dart';
import 'package:app/features/requests/presentation/pages/others_request_detail_page.dart';
// import 'package:app/features/requests/presentation/pages/request_detail_page.dart';
import 'package:app/features/shared/loading_page.dart';
import 'package:app/route/app_pages.dart';
import 'package:app/route/custom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyRequests extends StatefulWidget {
  final RequestBloc bloc;
  final LocationModel location;
  const MyRequests({super.key, required this.location, required this.bloc});

  @override
  State<MyRequests> createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestBloc, RequestState>(
      bloc: widget.bloc,
      buildWhen: (previous, current) =>
          current is MyRequestSuccess ||
          current is MyRequestLoading ||
          current is MyRequestEmpty ||
          current is MYRequestError,
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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OthersRequestDetailPage(
                    requestModel: requests[index],
                    requestType: RequestType.my,
                    requestBloc: widget.bloc,
                    // openReqBloc: widget.openReqBloc,
                  ),
                ),
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
}
