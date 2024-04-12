import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeltonContainer extends StatelessWidget {
  final double height, width, radius;
  const SkeltonContainer(
      {super.key,
      required this.height,
      required this.width,
      required this.radius});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).brightness == Brightness.dark
          ? const Color.fromARGB(255, 33, 32, 32)
          : const Color.fromARGB(255, 212, 210, 210),
      highlightColor: Theme.of(context).brightness == Brightness.dark
          ? const Color.fromARGB(255, 65, 63, 63)
          : const Color.fromARGB(255, 232, 231, 231),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
