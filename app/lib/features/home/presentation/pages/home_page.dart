import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/data/firestore_datasources/firestore.dart';
import 'package:app/core/managers/notification_manager.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/features/home/bloc/fcm_bloc.dart';
import 'package:app/features/home/presentation/blocs/open_request_bloc/open_req_bloc.dart';
import 'package:app/features/home/tab_views/my_request.dart';
import 'package:app/features/home/tab_views/other_request.dart';
import 'package:app/features/requests/presentation/blocs/request_bloc/request_bloc.dart';
import 'package:app/features/requests/presentation/models/location_model.dart';
import 'package:app/injection_container.dart';
import 'package:app/route/app_pages.dart';
import 'package:app/route/custom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  final LocationModel locationModel;
  const HomePage({super.key, required this.locationModel});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _reqRefBloc = sl.get<RequestBloc>();
  final _fcmbloc = FcmBloc();
  late OpenReqBloc _openReqRefBloc;
  final FireStoreDataSources fireStoreHelpers = FireStoreDataSources();

  @override
  void dispose() {
    _reqRefBloc.close();
    _openReqRefBloc.close();
    super.dispose();
  }

  @override
  void initState() {
    _openReqRefBloc = sl.get<OpenReqBloc>();
    FCMnotificationManager.requestPermission();
    FCMnotificationManager.getDeviceToken().then(
      (value) => _fcmbloc.add(
        FCMUpdateEvent(value),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _reqRefBloc.add(GetMyRequestEvent());
        _openReqRefBloc.add(
          OpenReqInitial(),
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => CustomNavigator.pushTo(context, AppPages.profilePage),
            child: Container(
              padding: EdgeInsets.all(8),
              height: 30,
              width: 30,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                  'https://i.pinimg.com/736x/f8/66/8e/f8668e5328cfb4938903406948383cf6.jpg',
                ),
              ),
            ),
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: AppColors.primary,
          ),
          centerTitle: true,
          title: const Text(
            'Clean my Town',
            style: AppStyles.appBarStyle,
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: TabBar(
              labelStyle: AppStyles.activetabStyle,
              unselectedLabelStyle: AppStyles.inActivetabStyle,
              dividerColor: AppColors.primary,
              indicatorColor: AppColors.primary,
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              physics: const ClampingScrollPhysics(),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('My Requests'),
                      CustomSpacers.width4,
                      BlocBuilder<RequestBloc, RequestState>(
                        bloc: _reqRefBloc,
                        builder: (context, state) {
                          if (state is MyRequestSuccess) {
                            return Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                              ),
                              child: Text(
                                state.requestModel.length.toString(),
                                textAlign: TextAlign.center,
                                style: AppStyles.roboto_14_500_light,
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      )
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Other Requests'),
                      CustomSpacers.width4,
                      BlocBuilder<OpenReqBloc, OpenReqState>(
                        bloc: _openReqRefBloc,
                        builder: (context, state) {
                          if (state is OpenReqLoaded) {
                            return Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                              ),
                              child: Text(
                                state.requests.length.toString(),
                                textAlign: TextAlign.center,
                                style: AppStyles.roboto_14_500_light,
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      )
                    ],
                  ),
                ),
                Tab(
                  text: 'Register Complains',
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            MyRequests(location: widget.locationModel),
            OthersRequest(
              openReqBloc: _openReqRefBloc,
            ),
            const Center(
              child: Text(
                'Register Complains',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
