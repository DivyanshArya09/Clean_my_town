// import 'package:app/core/constants/app_colors.dart';
// import 'package:app/core/managers/location_manager.dart';
// import 'package:app/core/styles/app_styles.dart';
// import 'package:app/features/home/tab_views/my_request.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   void initState() {
//     super.initState();
//     LocationManager.getLocation()
//         .then((value) =>
//             print('--------------------------------->${value.latitude}'))
//         .onError((error, stackTrace) =>
//             print('--------------------------------->$error'));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           systemOverlayStyle: const SystemUiOverlayStyle(
//             statusBarColor: AppColors.primary,
//           ),
//           centerTitle: true,
//           title: const Text('Clean my Town'),
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(kToolbarHeight),
//             child: TabBar(
//               labelStyle: AppStyles.activetabStyle,
//               unselectedLabelStyle: AppStyles.inActivetabStyle,
//               dividerColor: AppColors.primary,
//               indicatorColor: AppColors.primary,
//               tabAlignment: TabAlignment.start,
//               isScrollable: true,
//               physics: const ClampingScrollPhysics(),
//               tabs: const [
//                 Tab(
//                   text: 'My Requests',
//                 ),
//                 Tab(
//                   text: 'Open Requests',
//                 ),
//                 Tab(
//                   text: 'Register Complains',
//                 ),
//               ],
//             ),
//           ),
//         ),
//         body: const TabBarView(
//           physics: NeverScrollableScrollPhysics(),
//           children: [
//             MyRequests(),
//             Center(child: Text('Open Requests')),
//             Center(
//               child: Text(
//                 'Register Complains',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
