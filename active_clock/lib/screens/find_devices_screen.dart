import 'package:flutter/material.dart';
import '../elements/elements.dart';
import '../widgets/bonded_device_listview.dart';
import '../widgets/discover_devices_listview.dart';

class FindDevicesScreen extends StatefulWidget {
  const FindDevicesScreen();

  @override
  State<FindDevicesScreen> createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  @override
  void initState() {
    super.initState();
    _body = BondedDeviceListview();
    print("InitState called");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("DidChangeDependecies called");
  }

  late Widget _body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          title: "Active Clock",
          actions: [
            NavbarAction(
                label: "Paired Devices",
                action: () => setState(
                      () => _body = BondedDeviceListview(),
                    )),
            NavbarAction(
                label: "Add New Device",
                action: () => setState(
                      () => _body = DiscoverDevicesListView(),
                    )),
          ],
        ),
        body: Container(color: MyColors.white, child: _body));
  }
}
