import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/app_images.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/core/utils/toast_utils.dart';
import 'package:app/features/home/presentation/blocs/open_request_bloc/open_req_bloc.dart';
import 'package:app/features/home/widgets/request_tile.dart';
import 'package:app/features/requests/model/request_model.dart';
import 'package:app/features/requests/presentation/pages/others_request_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class OthersRequest extends StatefulWidget {
  final OpenReqBloc openReqBloc;
  const OthersRequest({super.key, required this.openReqBloc});
  @override
  State<OthersRequest> createState() => _OthersRequestState();
}

class _OthersRequestState extends State<OthersRequest> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OpenReqBloc, OpenReqState>(
      bloc: widget.openReqBloc,
      listener: (context, state) {
        if (state is OpenReqError) {
          ToastHelpers.showToast(state.message);
        }
      },
      builder: (context, state) {
        if (state is OpenReqLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is OpenReqLoaded && state.requests.isNotEmpty) {
          return _buildRequestBody(state.requests);
        }
        if (state is OpenReqError) {
          return Center(
            child: Text(state.message),
          );
        }
        return _buildEmptyBody();
      },
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
                'There is no active requests\nin your area...',
                textAlign: TextAlign.center,
                style: AppStyles.titleStyle,
              ),
              CustomSpacers.height30,
              SvgPicture.asset(
                AppImages.volunteers,
                height: MediaQuery.of(context).size.height * 0.35,
              ),
              CustomSpacers.height16,
            ],
          ),
        ],
      ),
    );
  }

  _buildRequestBody(List<RequestModel> requests) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OthersRequestDetailPage(
                      requestModel: requests[index],
                      openReqBloc: widget.openReqBloc,
                    ),
                  ),
                );
              },
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return CustomSpacers.height12;
        },
      ),
    );
  }
}
