import 'package:flutter/material.dart';

class MyBlinkWidget extends StatefulWidget {
  const MyBlinkWidget({required this.child});
  final Widget child;

  @override
  State<MyBlinkWidget> createState() => _MyBlinkWidgetState();
}

class _MyBlinkWidgetState extends State<MyBlinkWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
