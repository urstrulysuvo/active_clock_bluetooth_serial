import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../elements/elements.dart';
import '../extra_wigdet/my_background_painter.dart';

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              child: Container(
            color: MyColors.white,
          )),
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: MyBackgroundPainter(),
          ),
          Center(
            child: MyContainer(
              margin: EdgeInsets.all(24.0),
              borderRadius: 20.0,
              height: 320,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.bluetooth_disabled_rounded,
                      size: 128,
                      color: MyColors.black,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    const MyText(
                      label: "Please turn on the bluetooth",
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    const MyText(
                      label: "This is required in order to use Active Clock",
                      fontSize: MyFontSize.small,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),

                    MyButton(
                      onTap: () {
                        future() async {
                          await FlutterBluetoothSerial.instance.requestEnable();
                        }

                        future().then((value) => null);
                      },
                      child: MyBlinkWidget(
                        child: MyText(
                          label: "Turn On",
                          color: MyColors.white,
                        ),
                      ),
                    ),
                    // ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
