// import 'package:app/core/constants/app_colors.dart';
// import 'package:app/core/constants/app_images.dart';
// import 'package:app/core/constants/default_contants.dart';
// import 'package:app/core/managers/location_manager.dart';
// import 'package:app/core/styles/app_styles.dart';
// import 'package:app/core/utils/custom_spacers.dart';
// import 'package:app/features/home/widgets/request_tile.dart';
// import 'package:app/features/requests/model/request_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:url_launcher/url_launcher.dart';

// enum RequestType { myRequest, otherRequest }

// class RequestDetailPage extends StatefulWidget {
//   final RequestModel request;
//   final RequestType requestType;
//   const RequestDetailPage(
//       {super.key, required this.request, required this.requestType});

//   @override
//   State<RequestDetailPage> createState() => _RequestDetailPageState();
// }

// class _RequestDetailPageState extends State<RequestDetailPage> {
//   String startLat = '', startLng = '', endLat = '', endLng = '';
//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback(
//       (_) {
//         widget.requestType == RequestType.otherRequest
//             ? LocationManager.getLocation().then(
//                 (value) => {
//                   setState(
//                     () {
//                       startLat = value.latitude.toString();
//                       startLng = value.longitude.toString();
//                     },
//                   )
//                 },
//               )
//             : null;
//       },
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomSheet: widget.requestType == RequestType.otherRequest
//           ? _buildMapBottomSheet()
//           : _buildEditStatusBottomSheet(),
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             leading: IconButton(
//                 onPressed: () => Navigator.pop(context),
//                 icon: Icon(Icons.arrow_back_ios_new, color: AppColors.white)),
//             stretch: true,
//             expandedHeight: MediaQuery.of(context).size.height * .75,
//             flexibleSpace: Stack(
//               children: [
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height,
//                   width: MediaQuery.of(context).size.height,
//                   child: Image.network(
//                     widget.request.image,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: DEFAULT_Horizontal_PADDING,
//                     ),
//                     alignment: Alignment.centerRight,
//                     height: 60.h,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: Colors.white,
//                         width: 10,
//                       ),
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(20),
//                         topRight: Radius.circular(20),
//                       ),
//                     ),
//                     child: statusTab(widget.request.status),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: DEFAULT_Horizontal_PADDING,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text('Title', style: AppStyles.roboto_16_500_dark),
//                       CustomSpacers.height10,
//                       Text(
//                         widget.request.title,
//                         style: AppStyles.roboto_14_500_dark,
//                       ),
//                       CustomSpacers.height10,
//                       Text('Description', style: AppStyles.roboto_16_500_dark),
//                       Text(widget.request.description,
//                           style: AppStyles.roboto_14_500_dark),
//                       CustomSpacers.height10,
//                       Text('Location', style: AppStyles.roboto_16_500_dark),
//                       CustomSpacers.height10,
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * .9,
//                         child: Text(widget.request.fullAddress,
//                             softWrap: true, style: AppStyles.activetabStyle),
//                       ),
//                       CustomSpacers.height10,
//                       Text('Request created at',
//                           style: AppStyles.roboto_16_500_dark),
//                       CustomSpacers.height10,
//                       Text(
//                         widget.request.dateTime,
//                         style: AppStyles.roboto_14_500_dark,
//                       ),
//                       CustomSpacers.height10,
//                       Text('Contact Number',
//                           style: AppStyles.roboto_16_500_dark),
//                       CustomSpacers.height10,
//                       Text(
//                         '+91 9877698097',
//                         style: AppStyles.roboto_14_500_dark,
//                       ),
//                       CustomSpacers.height120,
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildEditStatusBottomSheet() {
//     return Container(
//       color: AppColors.primary,
//       padding: const EdgeInsets.symmetric(
//         horizontal: DEFAULT_Horizontal_PADDING,
//         vertical: 16,
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text('Update Status', style: AppStyles.roboto_16_700_light),
//           Spacer(),
//           Icon(Icons.update, color: AppColors.white),
//         ],
//       ),
//     );
//   }

//   Widget _buildMapBottomSheet() {
//     return Visibility(
//       visible: startLat.isNotEmpty && startLng.isNotEmpty,
//       child: InkWell(
//         onTap: () async {
//           // List<String> parts = widget.request.coordinates.split('-');
//           // endLat = parts[0].trim();
//           // endLng = parts[1].trim();
//           // await _openMapsForDirections(startLat, startLng, endLat, endLng);
//         },
//         child: Container(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: DEFAULT_Horizontal_PADDING),
//             height: 60.h,
//             width: MediaQuery.of(context).size.width,
//             color: AppColors.primary,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text('Tap to get directions',
//                     style: AppStyles.roboto_16_700_light),
//                 Image.asset(AppImages.mapIcon),
//               ],
//             )),
//       ),
//     );
//   }

//   Future<void> _openMapsForDirections(
//     String startLatitude,
//     String startLongitude,
//     String endLatitude,
//     String endLongitude,
//   ) async {
//     final url =
//         'https://www.google.com/maps/dir/?api=1&origin=$startLatitude,$startLongitude&destination=$endLatitude,$endLongitude';

//     print('url------------------------> $url');

//     try {
//       if (!await launchUrl(Uri.parse(url))) {
//         //  print('Error launching Google Maps: $e');
//         throw 'Could not launch $url';
//         // await launchUrl(url, forceSafariVC: false);
//       } else {
//         throw 'Could not launch $url';
//       }
//     } catch (e) {
//       print('Error launching Google Maps: $e');
//     }
//   }
// }
