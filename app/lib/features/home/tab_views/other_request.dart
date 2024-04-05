import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/app_images.dart';
import 'package:app/core/helpers/realtime_data_helpers/realtime_data_base_helper.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/core/utils/toast_utils.dart';
import 'package:app/features/add_request/model/request_model.dart';
import 'package:app/features/home/presentation/bloc/open_req_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class OthersRequest extends StatefulWidget {
  const OthersRequest({super.key});

  @override
  State<OthersRequest> createState() => _OthersRequestState();
}

class _OthersRequestState extends State<OthersRequest> {
  RealtimeDBHelper realtimeDBHelper = RealtimeDBHelper();
  final _refBloc = OpenReqBloc();
  @override
  void dispose() {
    _refBloc.close();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // realtimeDBHelper.getOthersRquest();
      _refBloc.add(GetOpenReqEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OpenReqBloc, OpenReqState>(
      bloc: _refBloc,
      listener: (context, state) {
        if (state is OpenReqLoaded) {
          ToastHelpers.showToast('success');
        }
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
          return ListTile(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) {
              //       return RequestDetailPage(request: requests[index]);
              //     },
              //   ),
              // );
            },
            tileColor: AppColors.white,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                  width: 60, child: Image.network(requests[index].image)),
            ),
            trailing: TextButton(
              onPressed: () {},
              child:
                  Text(requests[index].town, style: AppStyles.activetabStyle),
            ),
            title: Text(requests[index].title, style: AppStyles.titleStyle),
            subtitle: Text(
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              requests[index].description,
              style: AppStyles.roboto_14_500_dark,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            thickness: 1,
            color: AppColors.darkGray,
          );
        },
      ),
    );
  }
}
