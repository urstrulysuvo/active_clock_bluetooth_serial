import 'package:flutter/material.dart';

import 'elements.dart';

class MyListTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final AssetImage assetImage;
  final Function() onPressed;
  const MyListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.assetImage,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: MyContainer(
        shadowColor: Colors.white,
        shadowIntencity: 0.2,
        borderRadius: 20.0,
        padding: EdgeInsets.only(left: 4.0, right: 16.0),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  ImageIcon(
                    widget.assetImage,
                    color: MyColors.black,
                    size: 64,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          label: widget.title,
                        ),
                        SizedBox(height: 4.0),
                        MyText(
                          label: widget.subtitle,
                          fontSize: MyFontSize.small,
                          isDisable: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: MyButton(
                onTap: () async {
                  setState(() => _isLoading = true);
                  widget.onPressed();
                  await Future.delayed(Duration(milliseconds: 10000));
                  if (mounted) setState(() => _isLoading = false);
                },
                color: _isLoading ? MyColors.grey : null,
                child: MyBlinkWidget(
                    child: Icon(_isLoading
                        ? Icons.more_horiz_rounded
                        : Icons.keyboard_double_arrow_right_rounded)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
