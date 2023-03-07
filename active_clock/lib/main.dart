import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'screens/bluetooth_off_screen.dart';
import 'screens/find_devices_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FlutterBluetoothSerial.instance.state.then(
      (state) => setState(
        () {
          _bluetoothState = state;
        },
      ),
    );

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((state) => setState(() {
              _bluetoothState = state;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return _bluetoothState.isEnabled
        ? const FindDevicesScreen()
        : BluetoothOffScreen();
  }
}
