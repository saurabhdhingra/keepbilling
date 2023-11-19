import 'dart:io';

import 'package:flutter/material.dart';
import 'package:keepbilling/responsive/screen_type_layout.dart';
import '../../../utils/constants.dart';

class StatusButton extends StatefulWidget {
  final bool isSelected;
  final Function(String) setState;
  final String text;
  const StatusButton({
    Key? key,
    required this.isSelected,
    required this.setState,
    required this.text,
  }) : super(key: key);

  @override
  State<StatusButton> createState() => _StatusButtonState();
}

class _StatusButtonState extends State<StatusButton> {
  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);

    return GestureDetector(
      onTap: () {
        widget.setState(widget.text);
      },
      child: ScreenTypeLayout(
        mobile: Container(
          padding: const EdgeInsets.all(2.0),
          height: height * 0.05,
          width: width * 0.28,
          decoration: BoxDecoration(
            color: widget.isSelected
                ? const Color.fromARGB(165, 16, 196, 160)
                : Platform.isIOS
                    ? const Color.fromRGBO(235, 235, 235, 1)
                    : Colors.white,
            border: Platform.isIOS
                ? Border.all(
                    color: Colors.white,
                    width: 0,
                    style: BorderStyle.solid,
                  )
                : Border.all(
                    color: Colors.black,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: FittedBox(child: Text(widget.text)),
          ),
        ),
        tablet: Container(
          height: height * 0.05,
          width: width * 0.28,
          decoration: BoxDecoration(
            color: widget.isSelected
                ? const Color.fromRGBO(16, 196, 161, 1)
                : Platform.isIOS
                    ? const Color.fromRGBO(235, 235, 235, 1)
                    : Colors.white,
            border: Platform.isIOS
                ? Border.all(
                    color: Colors.white,
                    width: 0,
                    style: BorderStyle.solid,
                  )
                : Border.all(
                    color: Colors.black,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(fontSize: height * 0.02),
            ),
          ),
        ),
      ),
    );
  }
}
