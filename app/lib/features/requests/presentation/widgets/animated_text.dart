import 'package:app/core/styles/app_styles.dart';
import 'package:flutter/material.dart';

class AnimateText extends StatefulWidget {
  final String text;

  const AnimateText({Key? key, required this.text}) : super(key: key);

  @override
  State<AnimateText> createState() => _AnimateTextState();
}

class _AnimateTextState extends State<AnimateText>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween<double>(begin: 0.0, end: 10.0).animate(_controller)
      ..addListener(() => setState(() {}));
    _controller.repeat(
        reverse:
            true); // Set to repeat and reverse for continuous up-down movement
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0.0, _animation.value),
        child: Text(
          widget.text,
          style: AppStyles.roboto_14_500_dark,
        ),
      ),
    );
  }
}
