import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  const MyContainer({
    required this.child,
    required this.height,
    this.margin = const EdgeInsets.all(0.0),
    this.padding = const EdgeInsets.all(0.0),
    this.borderRadius = 10.0,
    this.shadowIntencity = 1.0,
    this.shadowColor = const Color(0xFFD7DADB),
    this.color = Colors.white,
  });
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double height;
  final double borderRadius;
  final double shadowIntencity;
  final Color shadowColor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: margin,
      padding: padding,
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.5),
            spreadRadius: 3 * shadowIntencity,
            blurRadius: 6 * shadowIntencity,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
