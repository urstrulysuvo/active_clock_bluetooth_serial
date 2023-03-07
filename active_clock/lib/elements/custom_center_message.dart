import 'package:flutter/material.dart';

import 'elements.dart';

Widget customCenterMessage(String message) {
  return Center(
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        //color: Colors.white10,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: MyText(
          label: message,
          color: MyColors.black,
        ),
      ),
    ),
  );
}
