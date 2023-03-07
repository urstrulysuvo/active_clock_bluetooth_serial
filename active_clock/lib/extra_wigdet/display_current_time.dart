import 'dart:async';
import 'package:flutter/material.dart';

import '../elements/elements.dart';

class DisplayCurrentTime extends StatefulWidget {
  const DisplayCurrentTime({Key? key}) : super(key: key);

  @override
  State<DisplayCurrentTime> createState() => _DisplayCurrentTimeState();
}

class _DisplayCurrentTimeState extends State<DisplayCurrentTime> {
  late Duration _duration;
  Timer? timer;

  @override
  void initState() {
    _startTimer();
    DateTime dt = DateTime.now();
    _duration =
        Duration(hours: dt.hour, minutes: dt.minute, seconds: dt.second);

    super.initState();
  }

  void _addSecond() {
    if (mounted) {
      setState(() {
        int seconds = _duration.inSeconds + 1;
        _duration = Duration(seconds: seconds);
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        customText(_duration.inHours.remainder(24)),
        const SizedBox(width: 15.0),
        const MyText(
          label: ':',
          fontSize: MyFontSize.extraLarge,
          fontWeight: MyFontWeight.light,
        ),
        const SizedBox(width: 15.0),
        customText(_duration.inMinutes.remainder(60)),
        const SizedBox(width: 15.0),
        const MyText(
          label: ':',
          fontSize: MyFontSize.extraLarge,
          fontWeight: MyFontWeight.light,
        ),
        const SizedBox(width: 15.0),
        customText(_duration.inSeconds.remainder(60))
      ],
    );
  }

  Widget customText(int time) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: Center(
          child: MyText(
            label: twoDigits(time),
            fontSize: MyFontSize.extraLarge,
            fontWeight: MyFontWeight.light,
          ),
        ));
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _addSecond();
    });
  }
}
