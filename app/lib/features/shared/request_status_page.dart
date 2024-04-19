import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/app_images.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/features/requests/presentation/blocs/map_bloc/map_bloc.dart';
import 'package:app/features/requests/presentation/models/request_model.dart';
import 'package:app/injection_container.dart';
import 'package:app/route/app_pages.dart';
import 'package:app/ui/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestStatusPage extends StatelessWidget {
  final String area;
  final Coordinates destination;
  const RequestStatusPage({
    super.key,
    required this.area,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomSpacers.height120,
                Container(
                  height: MediaQuery.of(context).size.width * .4,
                  width: MediaQuery.of(context).size.width * .4,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(.2),
                  ),
                  child: Image.asset(AppImages.success),
                ),
                CustomSpacers.height12,
                Text(
                  'You Rock!  Just Accepted\na Cleaning Request!',
                  textAlign: TextAlign.center,
                  style: AppStyles.roboto_16_500_dark,
                ),
                CustomSpacers.height12,
                Text(
                  'Boom! You just became a champion  ${area.isEmpty ? '' : 'for $area '}! By accepting to clean, you\'re not just picking up trash, you\'re creating a ripple effect of positive change.',
                  textAlign: TextAlign.center,
                  style: AppStyles.roboto_14_400_dark,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    btnTxt: 'Back to home',
                    onTap: () {
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName(
                          AppPages.home,
                        ),
                      );
                    },
                  ),
                  CustomSpacers.height12,
                  BlocBuilder<MapBloc, MapState>(
                    bloc: sl.get<MapBloc>(),
                    builder: (context, state) {
                      if (state is MapLoading) {
                        return CustomButton(
                          btnTxt: 'Get Directions',
                          centerWidget: Center(
                            child: Image.asset(AppImages.loading),
                          ),
                          onTap: () {},
                          btnType: ButtonType.secondary,
                        );
                      }
                      return CustomButton(
                        btnTxt: 'Get Directions',
                        onTap: () {
                          sl.get<MapBloc>().add(
                                LaunchGoogleMaps(
                                  destination: destination,
                                ),
                              );
                        },
                        btnType: ButtonType.secondary,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
