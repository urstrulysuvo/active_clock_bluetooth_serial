import 'package:flutter/material.dart';

import '../extra_wigdet/my_background_painter.dart';
import 'my_color.dart';
import 'my_container.dart';
import 'my_text.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize = const Size(double.infinity, double.maxFinite);

  const MyAppBar({
    required this.actions,
    required this.title,
    this.isSecondary = false,
  });

  final List<NavbarAction> actions;
  final String title;
  final bool isSecondary;
  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.22 + 28,
      color: MyColors.white,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0.0,
            left: 0.0,
            height: (size.height * 0.22),
            width: size.width,
            child: Container(
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  spreadRadius: 3,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ]),
              child: CustomPaint(
                painter: MyPainter(),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: MyColors.red.withOpacity(0.6),
            ))),
            height: size.height * 0.22,
            child: Center(
                child: MyText(
              label: widget.title,
              fontSize: MyFontSize.large,
            )),
          ),
          Positioned(
            height: 56.0,
            width: size.width * 0.8,
            left: size.width * 0.1,
            top: size.height * 0.22 - 28,
            child: MyContainer(
              height: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: widget.isSecondary
                    ? secondaryActionList(size.width * 0.8)
                    : mainActionList(size.width * 0.8),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> mainActionList(double width) {
    List<Widget> widgets = [];

    final int length = widget.actions.length;
    width -= length - 1;
    width /= length;

    for (int i = 0; i < length; i++) {
      widgets.add(
        InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: SizedBox(
            height: 56,
            width: width,
            child: Center(
              child: Text(
                widget.actions[i].label,
                style: TextStyle(
                    fontSize: 16,
                    color: index == i ? MyColors.black : MyColors.grey),
              ),
            ),
          ),
          onTap: () {
            var action = widget.actions[i].action;
            action.call();
            setState(() => index = i);
          },
        ),
      );
      widgets.add(
        Container(
          alignment: Alignment.center,
          width: 1,
          height: 56,
          color: MyColors.grey,
        ),
      );
    }

    widgets.removeLast();

    return widgets;
  }

  secondaryActionList(double width) {
    List<Widget> widgets = [];
    widgets.add(
      InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        onTap: widget.actions[0].action,
        child: SizedBox(
          height: 56,
          width: width * 0.3 - 1,
          child: Center(
            child: Icon(Icons.keyboard_arrow_left_rounded,
                size: 20, color: MyColors.black),
          ),
        ),
      ),
    );
    widgets.add(
      Container(
        alignment: Alignment.center,
        width: 1,
        height: 56,
        color: MyColors.grey,
      ),
    );
    widgets.add(SizedBox(
      height: 56,
      width: width * 0.7,
      child: Center(
        child: Text(
          widget.actions[0].label,
          style: TextStyle(fontSize: 16, color: MyColors.black),
        ),
      ),
    ));

    return widgets;
  }
}

class NavbarAction {
  final String label;
  final Function() action;

  NavbarAction({
    required this.label,
    required this.action,
  });
}
