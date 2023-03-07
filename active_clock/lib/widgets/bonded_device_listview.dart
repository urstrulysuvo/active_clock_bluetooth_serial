import 'dart:async';
import 'package:active_clock/screens/connected_device_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../elements/custom_center_message.dart';
import '../elements/my_listtile.dart';
import '../elements/custom_progress_indicator.dart';

class BondedDeviceListview extends StatefulWidget {
  final bool checkAvailability;

  const BondedDeviceListview({this.checkAvailability = true});

  @override
  _BondedDeviceListview createState() => new _BondedDeviceListview();
}

class _BondedDeviceListview extends State<BondedDeviceListview> {
  bool _isSearching = true;

  List<BluetoothDevice> _pairedDevices = [];

  // Availability
  StreamSubscription<BluetoothDiscoveryResult>? _discoveryStreamSubscription;
  bool _isDiscovered = false;

  _BondedDeviceListview();

  @override
  void initState() {
    super.initState();

    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) async {
      await Future.delayed(Duration(milliseconds: 1000));
      if (mounted) {
        setState(() {
          _pairedDevices = bondedDevices;
          _isSearching = false;
        });
      }
    });
  }

  void _restartDiscovery() {
    print("--------------------Restart Discovery------------------");
    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) async {
      await Future.delayed(Duration(milliseconds: 1000));
      if (mounted) {
        setState(() {
          _pairedDevices = bondedDevices;
          _isSearching = false;
        });
      }
    });
  }

  void isAvailable(BluetoothDevice device) {
    _discoveryStreamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) async {
      if (r.device.address == device.address) {
        _isDiscovered = true;

        _discoveryStreamSubscription!.cancel();
        bool? result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConnectedDeviceScreen(server: r.device)));
        print(result);
        if (result ?? true) {
          if (mounted)
            setState(() {
              _isDiscovered = false;
              _isSearching = true;
              _pairedDevices = [];
              _restartDiscovery();
            });
        }
      }
    });
    //});

    _discoveryStreamSubscription?.onDone(() {
      print("222");
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _discoveryStreamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<MyListTile> pairedDevices = _pairedDevices
        .map((device) => MyListTile(
            title: device.name ?? "Unknown",
            subtitle: device.address,
            assetImage: AssetImage("images/clock.png"),
            onPressed: () {
              if (!_isDiscovered) {
                isAvailable(device);
              }
            }))
        .toList();

    return _isSearching
        ? CustomProgressIndicator()
        : pairedDevices.isEmpty
            ? customCenterMessage("No paired device found")
            : NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overscroll) {
                  overscroll.disallowIndicator();
                  return true;
                },
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    itemCount: pairedDevices.length,
                    itemBuilder: ((context, index) => pairedDevices[index])));
  }
}
