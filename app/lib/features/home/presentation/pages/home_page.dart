import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/helpers/helper.dart';
import 'package:app/core/managers/location_manager.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/toast_utils.dart';
import 'package:app/features/add_request/presentation/bloc/geolocator_bloc.dart';
import 'package:app/features/home/firestore_helpers/firestore_helpers.dart';
import 'package:app/features/home/tab_views/my_request.dart';
import 'package:app/features/home/tab_views/other_request.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      LocationManager.getLocation().then((value) {
        _geofenceBloc
            .add(GetLocation(lat: value.latitude, long: value.longitude));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: AppColors.primary,
          ),
          centerTitle: true,
          title: const Text('Clean my Town'),
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
              SharedPreferencesHelper.setLocation(
                state.locationModel.address.town.isEmpty
                    ? state.locationModel.address.state
                    : state.locationModel.address.town,
              );
              fireStoreHelpers.updatelocation(
                state.locationModel.address.town.isEmpty
                    ? state.locationModel.address.state
                    : state.locationModel.address.town,
              );
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
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
