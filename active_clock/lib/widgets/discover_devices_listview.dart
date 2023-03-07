import 'dart:async';
import 'package:active_clock/elements/custom_alert_dialog.dart';
import 'package:active_clock/elements/my_listtile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../elements/custom_center_message.dart';
import '../elements/custom_progress_indicator.dart';

class DiscoverDevicesListView extends StatefulWidget {
  final bool start;
  const DiscoverDevicesListView({Key? key, this.start = true})
      : super(key: key);

  @override
  State<DiscoverDevicesListView> createState() =>
      _DiscoverDevicesListViewState();
}

class _DiscoverDevicesListViewState extends State<DiscoverDevicesListView> {
  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  List<BluetoothDiscoveryResult> results =
      List<BluetoothDiscoveryResult>.empty(growable: true);
  bool _isDiscovering = false;

  _DiscoverDevicesListViewState();

  @override
  void initState() {
    super.initState();

    _isDiscovering = widget.start;
    if (_isDiscovering) {
      _startDiscovery();
    }
  }

  void _startDiscovery() {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        final existingIndex = results.indexWhere(
            (element) => element.device.address == r.device.address);
        if (existingIndex >= 0)
          results[existingIndex] = r;
        else {
          if (!(r.device.isBonded)) results.add(r);
        }
      });
    });

    _streamSubscription!.onDone(() {
      setState(() {
        _isDiscovering = false;
      });
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatoryKey =
        new GlobalKey<NavigatorState>();

    print(navigatoryKey.currentContext.toString());

    return _isDiscovering
        ? CustomProgressIndicator()
        : results.isEmpty
            ? customCenterMessage("No new device found")
            : NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overscroll) {
                  overscroll.disallowIndicator();
                  return true;
                },
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  itemCount: results.length,
                  itemBuilder: (BuildContext context, index) {
                    BluetoothDiscoveryResult result = results[index];
                    final device = result.device;
                    final address = device.address;
                    return MyListTile(
                      title: device.name ?? "Unknown",
                      subtitle: device.address,
                      onPressed: () async {
                        try {
                          bool bonded = false;
                          print('Bonding with ${device.address}...');
                          bonded = (await FlutterBluetoothSerial.instance
                              .bondDeviceAtAddress(address))!;
                          print(
                              'Bonding with ${device.address} has ${bonded ? 'succed' : 'failed'}.');
                          if (bonded)
                            setState(() {
                              results.remove(result);
                            });
                        } catch (ex) {
                          showDialog(
                            context: navigatoryKey.currentContext ?? context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return customAlertDialog(context, ex);
                            },
                          );
                        }
                      },
                      assetImage: AssetImage("images/clock.png"),
                    );
                  },
                ),
              );
  }
}
