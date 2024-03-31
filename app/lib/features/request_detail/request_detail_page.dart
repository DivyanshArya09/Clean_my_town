import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/app_images.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:app/core/managers/location_manager.dart';
import 'package:app/core/styles/app_styles.dart';
import 'package:app/core/utils/custom_spacers.dart';
import 'package:app/features/add_request/model/request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestDetailPage extends StatefulWidget {
  final RequestModel request;
  const RequestDetailPage({super.key, required this.request});

  @override
  State<RequestDetailPage> createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  String startLat = '', startLng = '', endLat = '', endLng = '';
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LocationManager.getLocation().then((value) => {
            setState(() {
              startLat = value.latitude.toString();
              startLng = value.longitude.toString();
            })
          });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomSheet: Visibility(
        visible: startLat.isNotEmpty && startLng.isNotEmpty,
        child: InkWell(
          onTap: () async {
            List<String> parts = widget.request.location.split('-');
            print('parts---------------------------------------> $parts');
            endLat = parts[0].trim();
            endLng = parts[1].trim();
            await _openMapsForDirections(startLat, startLng, endLat, endLng);
          },
          child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: DEFAULT_Horizontal_PADDING),
              height: 60.h,
              width: MediaQuery.of(context).size.width,
              color: AppColors.primary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Tap to get directions',
                      style: AppStyles.roboto_16_700_light),
                  Image.asset(AppImages.mapIcon),
                ],
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .5,
              width: MediaQuery.of(context).size.height,
              child: Image.network(
                widget.request.image,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: DEFAULT_Horizontal_PADDING,
                  vertical: DEFAULT_VERTICAL_PADDING),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Title', style: AppStyles.roboto_16_500_dark),
                  Text(
                    widget.request.title,
                    style: AppStyles.headingDark,
                  ),
                  CustomSpacers.height10,
                  Text('Description', style: AppStyles.roboto_16_500_dark),
                  Text(widget.request.description),
                  CustomSpacers.height10,
                  Text('City', style: AppStyles.roboto_16_500_dark),
                  Text(widget.request.town),
                  CustomSpacers.height10,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openMapsForDirections(
    String startLatitude,
    String startLongitude,
    String endLatitude,
    String endLongitude,
  ) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&origin=$startLatitude,$startLongitude&destination=$endLatitude,$endLongitude';

    print('url------------------------> $url');

    try {
      if (!await launchUrl(Uri.parse(url))) {
        //  print('Error launching Google Maps: $e');
        throw 'Could not launch $url';
        // await launchUrl(url, forceSafariVC: false);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching Google Maps: $e');
    }
  }
}
