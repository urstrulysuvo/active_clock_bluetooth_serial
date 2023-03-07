import 'package:flutter/material.dart';

import 'elements.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 3.0,
        //minHeight: 10,
        backgroundColor: MyColors.grey,
        valueColor: AlwaysStoppedAnimation<Color>(
          MyColors.red,
        ),
      ),
    );
  }
}
