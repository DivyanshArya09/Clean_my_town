import 'package:app/core/constants/app_colors.dart';
import 'package:app/core/constants/default_contants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeltonContainer extends StatelessWidget {
  final double height, width;
  final double? radius;
  const SkeltonContainer({
    super.key,
    required this.height,
    required this.width,
    this.radius = DEFAULT_BORDER_RADIUS,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 210, 211, 209),
      highlightColor: AppColors.white.withOpacity(.5),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 210, 211, 209),
          borderRadius: BorderRadius.circular(radius!),
        ),
      ),
    );
  }
}
