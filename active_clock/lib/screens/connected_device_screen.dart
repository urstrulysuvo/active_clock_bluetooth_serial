import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../elements/elements.dart';
import '../extra_wigdet/display_current_time.dart';

class ConnectedDeviceScreen extends StatefulWidget {
  final BluetoothDevice server;

  const ConnectedDeviceScreen({required this.server});

  @override
  _ConnectedDeviceScreen createState() => new _ConnectedDeviceScreen();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ConnectedDeviceScreen extends State<ConnectedDeviceScreen> {
  bool _setupModeOn = false;
  bool isWaiting = false;
  String status = "connecting";

  BluetoothConnection? connection;

  List<_Message> messages = List<_Message>.empty(growable: true);
  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  //final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();
    if (!isConnected) {
      BluetoothConnection.toAddress(widget.server.address).then((_connection) {
        print('Connected to the device');
        connection = _connection;
        if (this.mounted)
          setState(() {
            isConnecting = false;
            isDisconnecting = false;
          });

        connection!.input!.listen(_onDataReceived).onDone(() {
          if (isDisconnecting) {
            print('Disconnecting locally!');
          } else {
            print('Disconnected remotely!');
          }
          if (this.mounted) {
            setState(() {});
          }
        });
      }).catchError((error) {
        print('Cannot connect, exception occured');
        throw error;
      });
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.78 - 108;
    return Scaffold(
      appBar: MyAppBar(
        isSecondary: true,
        title: "Active Clock",
        actions: [
          NavbarAction(
              label: widget.server.name ?? "Unknown",
              action: () {
                Navigator.pop(context, true);
              }),
        ],
      ),
      body: Container(
          color: MyColors.white,
          height: height + 108,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  MyContainer(
                    shadowColor: Colors.white,
                    shadowIntencity: 0.2,
                    borderRadius: 20.0,
                    margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                    padding: const EdgeInsets.all(20.0),
                    height: height * 0.25,
                    child: const DisplayCurrentTime(),
                  ),
                  MyContainer(
                    shadowColor: Colors.white,
                    shadowIntencity: 0.2,
                    borderRadius: 20.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    height:
                        _setupModeOn ? height * 0.48 + 1 : height * 0.24 + 1,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          height: height * .12,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const MyText(label: "Status "),
                                  MyBlinkWidget(
                                    child: Icon(
                                        Icons.keyboard_arrow_right_rounded,
                                        size: 26.0,
                                        color: MyColors.black),
                                  )
                                ],
                              ),
                              MyText(label: status)
                            ],
                          ),
                        ),
                        Container(
                          height: 1.0,
                          color: MyColors.grey,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          height: height * .12,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const MyText(label: "Setup Mode"),
                              MyButton(
                                color: isWaiting ? MyColors.grey : null,
                                onTap: _setupModeOn
                                    ? () async {
                                        if (isConnected) _sendMessage("110");
                                        setState(() {
                                          _setupModeOn = false;
                                        });
                                      }
                                    : () async {
                                        if (isConnected) _sendMessage("200");
                                        setState(
                                          () => isWaiting = true,
                                        );
                                        await Future.delayed(
                                            Duration(milliseconds: 2000));
                                        setState(
                                          () {
                                            _setupModeOn = true;
                                            isWaiting = false;
                                          },
                                        );
                                      },
                                child: _setupModeOn
                                    ? const Icon(
                                        Icons.cancel_outlined,
                                        size: 26.0,
                                      )
                                    : MyBlinkWidget(
                                        child: Icon(
                                            isWaiting
                                                ? Icons.more_horiz_rounded
                                                : Icons
                                                    .keyboard_double_arrow_right_rounded,
                                            size: 26.0,
                                            color: MyColors.white),
                                      ),
                              )
                            ],
                          ),
                        ),
                        if (_setupModeOn)
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            height: height * .24,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: height * .1,
                                  child: TextField(
                                    style: const TextStyle(fontSize: 15.0),
                                    controller: textEditingController,
                                    decoration: InputDecoration(
                                      prefixIcon:
                                          const Icon(Icons.message_outlined),
                                      hintText: isConnecting
                                          ? 'Wait until connected'
                                          : isConnected
                                              ? 'Type Your Message'
                                              : 'Chat got disconnected',
                                      hintStyle:
                                          TextStyle(color: MyColors.grey),
                                      filled: true,
                                      fillColor: Colors.white70,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15.0)),
                                        borderSide: BorderSide(
                                            color: MyColors.grey, width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15.0)),
                                        borderSide:
                                            BorderSide(color: MyColors.red),
                                      ),
                                    ),
                                    enabled: isConnected,
                                  ),
                                ),
                                SizedBox(
                                  height: height * .14,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Expanded(
                                          child: MyButton(
                                        color: isWaiting ? MyColors.grey : null,
                                        onTap: isConnected
                                            ? () async {
                                                DateTime _dt = DateTime.now();
                                                String message =
                                                    _dt.weekday.toString() +
                                                        "," +
                                                        _dt.hour.toString() +
                                                        ":" +
                                                        _dt.minute.toString() +
                                                        ":" +
                                                        _dt.second.toString() +
                                                        "," +
                                                        _dt.day.toString() +
                                                        "/" +
                                                        _dt.month.toString() +
                                                        "/" +
                                                        _dt.year.toString();

                                                _sendMessage(message);
                                                setState(
                                                    () => isWaiting = true);
                                                await Future.delayed(Duration(
                                                    milliseconds: 2000));
                                                setState(
                                                  () {
                                                    isWaiting = false;
                                                    _setupModeOn = false;
                                                  },
                                                );
                                              }
                                            : null,
                                        child: isWaiting
                                            ? MyBlinkWidget(
                                                child: Icon(
                                                    Icons.more_horiz_rounded,
                                                    size: 26.0,
                                                    color: MyColors.white))
                                            : MyText(
                                                label: "Set Time",
                                                color: MyColors.white,
                                              ),
                                      )),
                                      const SizedBox(width: 10.0),
                                      Expanded(
                                        child: MyButton(
                                          color:
                                              isWaiting ? MyColors.grey : null,
                                          onTap: isConnected
                                              ? () async {
                                                  String txt =
                                                      textEditingController
                                                          .text;
                                                  if (txt.isNotEmpty) {
                                                    _sendMessage("msg" + txt);
                                                    setState(
                                                        () => isWaiting = true);
                                                    await Future.delayed(
                                                        Duration(
                                                            milliseconds:
                                                                2000));
                                                    setState(
                                                      () {
                                                        isWaiting = false;
                                                        _setupModeOn = false;
                                                      },
                                                    );
                                                  }
                                                }
                                              : null,
                                          child: isWaiting
                                              ? MyBlinkWidget(
                                                  child: Icon(
                                                      Icons.more_horiz_rounded,
                                                      size: 26.0,
                                                      color: MyColors.white))
                                              : MyText(
                                                  label: "Set Message",
                                                  color: MyColors.white,
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void _onDataReceived(Uint8List data) {
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      status = backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString.substring(0, index);
      _messageBuffer = dataString.substring(index);
      if (this.mounted)
        setState(() {
          status = status.trim();
        });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;
        setState(() {});
      } catch (e) {
        setState(() {});
      }
    }
  }
}
