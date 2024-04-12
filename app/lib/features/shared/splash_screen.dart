import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/app_images.dart';
import 'package:app/core/helpers/user_helper.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/features/home/presentation/auth_gate.dart';
import 'package:app/features/requests/presentation/blocs/geolocator_bloc/geolocator_bloc.dart';
import 'package:app/features/shared/getting_location_page.dart';
import 'package:app/route/app_pages.dart';
import 'package:app/route/custom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  final bool? isUserLoggingIn;
  const SplashScreen({super.key, this.isUserLoggingIn});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _geofenceBloc = GeolocatorBloc();
  String? user;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SharedPreferencesHelper.getUser().then((value) {
        if (value != null) {
          user = value;
          setState(() {});
        }
      });
      _geofenceBloc.add(GetCurrentLatLang());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<GeolocatorBloc, GeolocatorState>(
        bloc: _geofenceBloc,
        listener: (context, state) {
          if (state is GeolocatorSuccess) {
            if (user != null) {
              CustomNavigator.pushTo(
                context,
                AppPages.home,
                arguments: state.locationModel,
              );
            } else {
              CustomNavigator.pushTo(context, AppPages.signup);
            }
          }
        },
        builder: (context, state) {
          if (state is GeolocatorSuccess) {
            return AuthGate();
          }
          if (state is GeolocatorError) {
            return Center(
              child: Text(state.error),
            );
          }
          // if (state is GeolocatorLoading) {
          //   return GettingLocationPage();
          // }
          return widget.isUserLoggingIn ?? false
              ? GettingLocationPage()
              : Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: AppColors.lightGray),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('We\'ve been waiting for you.',
                          style: AppStyles.headingDark),
                      CustomSpacers.height40,
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: SvgPicture.asset(
                          AppImages.splashScreenImage,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    ],
                  ),
                );
        },
      ),
    );
  }
}
































// import 'package:app/core/constants/app_colors.dart';
// import 'package:flutter/material.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   late Tween<double> _tween;

//   @override
//   void initState() {
//     _animationController = AnimationController(
//         duration: const Duration(milliseconds: 200), vsync: this);

//     _tween = Tween(begin: 0.0, end: 1);
//     _animation = _tween.animate(_animationController);

//     _animationController.forward();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: AnimatedBuilder(
//         animation: _animationController,
//         builder: (_, child) {
//           return Center(
//             child: Container(
//               clipBehavior: Clip.none,
//               alignment: Alignment.center,
//               height: MediaQuery.of(context).size.height * _animation.value,
//               width: MediaQuery.of(context).size.width * _animation.value,
//               decoration: BoxDecoration(
//                 color: AppColors.primary,
//                 shape: MediaQuery.of(context).size.width >
//                         MediaQuery.of(context).size.width * _animation.value
//                     ? BoxShape.circle
//                     : BoxShape.values.first,
//                 borderRadius: MediaQuery.of(context).size.width <=
//                         MediaQuery.of(context).size.width * _animation.value
//                     ? BorderRadius.circular(MediaQuery.of(context).size.height *
//                         (1 - _animation.value))
//                     : null,
//                 // shape: BoxShape.circle,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
