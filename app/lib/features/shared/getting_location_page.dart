import 'package:app/core/constants/app_images.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/features/requests/presentation/blocs/geolocator_bloc/geolocator_bloc.dart';
import 'package:app/features/shared/animated_container.dart';
import 'package:app/route/app_pages.dart';
import 'package:app/route/custom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GettingLocationPage extends StatefulWidget {
  const GettingLocationPage({super.key});

  @override
  State<GettingLocationPage> createState() => _GettingLocationPageState();
}

class _GettingLocationPageState extends State<GettingLocationPage> {
  late GeolocatorBloc _referenceBloc;

  @override
  void initState() {
    _referenceBloc = GeolocatorBloc();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _referenceBloc.add(GetCurrentLatLang());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Positioned.fill(
            child: Image.asset(
              AppImages.mapImage,
              fit: BoxFit.cover,
            ),
          ),
          // Positioned.fill(
          //   child: Container(
          //     color: Colors.black.withOpacity(0.3),
          //   ),
          // ),
          BlocConsumer<GeolocatorBloc, GeolocatorState>(
            bloc: _referenceBloc,
            listener: (context, state) {
              if (state is GeolocatorSuccess) {
                Future.delayed(
                  const Duration(seconds: 4),
                  () {
                    CustomNavigator.pushTo(
                      context,
                      AppPages.home,
                      arguments: state.locationModel,
                    );
                  },
                );
              }
            },
            builder: (context, state) {
              if (state is GeolocatorSuccess) {
                return Align(
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppImages.markerIcon, height: 40.h),
                        CustomSpacers.width16,
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            softWrap: true,
                            state.locationModel.displayName,
                            style: AppStyles.headingDark,
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(
                        duration: Duration(
                          seconds: 3,
                        ),
                      )
                      .then()
                      .moveY(
                        begin: 0,
                        duration: Duration(seconds: 2),
                        end: -MediaQuery.of(context).size.height,
                      )
                      .fadeOut(
                        duration: Duration(
                          seconds: 1,
                        ),
                      ),
                );
              }

              if (state is GeolocatorError)
                return Align(
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Some thing went wrong',
                      style: AppStyles.headingDark,
                    ),
                  ),
                );

              return Align(
                alignment: Alignment.center,
                child: CustomAnimatedContainer(
                  height: MediaQuery.of(context).size.width * 0.6,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
