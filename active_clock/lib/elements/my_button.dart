import 'package:flutter/material.dart';

import 'my_color.dart';

class MyButton extends StatelessWidget {
  const MyButton({required this.child, required this.onTap, this.color});
  final Widget child;
  final Function()? onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        backgroundColor: color ?? MyColors.red,
        shape: const StadiumBorder(),
      ),
      child: child,
    );
  }
}
