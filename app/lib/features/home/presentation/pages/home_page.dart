import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/helpers/firestore_helpers/firestore_helpers.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/toast_utils.dart';
import 'package:app/features/add_request/presentation/bloc/geolocator_bloc.dart';
import 'package:app/features/home/tab_views/my_request.dart';
import 'package:app/features/home/tab_views/other_request.dart';
import 'package:app/features/shared/getting_location_page.dart';
import 'package:app/route/app_pages.dart';
import 'package:app/route/custom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _geofenceBloc = GeolocatorBloc();
  final FireStoreHelpers fireStoreHelpers = FireStoreHelpers();

  @override
  void dispose() {
    _geofenceBloc.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _geofenceBloc.add(GetCurrentLatLang());
      },
    );
    super.didChangeDependencies();
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
            child: BlocBuilder<GeolocatorBloc, GeolocatorState>(
              bloc: _geofenceBloc,
              builder: (context, state) {
                if (state is GeolocatorSuccess)
                  return TabBar(
                    labelStyle: AppStyles.activetabStyle,
                    unselectedLabelStyle: AppStyles.inActivetabStyle,
                    dividerColor: AppColors.primary,
                    indicatorColor: AppColors.primary,
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    physics: const ClampingScrollPhysics(),
                    tabs: const [
                      Tab(
                        text: 'My Requests',
                      ),
                      Tab(
                        text: 'Open Requests',
                      ),
                      Tab(
                        text: 'Register Complains',
                      ),
                    ],
                  );

                return SizedBox.shrink();
              },
            ),
          ),
        ),
        body: BlocConsumer<GeolocatorBloc, GeolocatorState>(
          bloc: _geofenceBloc,
          listener: (context, state) {
            if (state is GeolocatorError) {
              ToastHelpers.showToast(state.error);
            }
            if (state is GeolocatorSuccess) {
              ToastHelpers.showToast(
                  'Got location ${state.locationModel.address.stateDistrict}');
            }
            if (state is LocationUpdateFailure) {
              ToastHelpers.showToast('Failed to get location');
            }
          },
          builder: (context, state) {
            if (state is GeolocatorSuccess) {
              return TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  MyRequests(location: state.locationModel),
                  const OthersRequest(),
                  const Center(
                    child: Text(
                      'Register Complains',
                    ),
                  ),
                ],
              );
            }
            return const GettingLocationPage();
          },
        ),
      ),
    );
  }
}
