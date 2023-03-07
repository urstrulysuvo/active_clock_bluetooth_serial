import 'package:flutter/material.dart';

import 'elements.dart';

Widget customAlertDialog(BuildContext context, Object ex) {
  return Center(
    child: MyContainer(
      shadowColor: Colors.white,
      shadowIntencity: 0.5,
      height: 180,
      margin: EdgeInsets.all(24.0),
      child: AlertDialog(
        actionsPadding: EdgeInsets.all(0.0),
        insetPadding: EdgeInsets.all(0.0),
        elevation: 0.0,
        titlePadding: EdgeInsets.all(0.0),
        contentPadding: EdgeInsets.fromLTRB(16.0, 2.0, 16.0, 12.0),
        backgroundColor: Color.fromARGB(0, 255, 193, 7),
        title: Center(
          child: MyText(
            label: "Error occured while bonding",
            color: MyColors.black,
          ),
        ),
        content: Text(
          "Another bonding process is going from the device",
          style: TextStyle(color: MyColors.black),
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: MyButton(
              child: MyBlinkWidget(
                  child: MyText(
                label: "Close",
                color: MyColors.white,
              )),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    ),
  );
}
