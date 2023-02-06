import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchButton extends StatefulWidget {
  final Function(bool) setState;
  final bool value;

  const SwitchButton({Key? key, required this.setState, required this.value})
      : super(key: key);

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoSwitch(
            value: widget.value,
            onChanged: (value) {
              widget.setState(value);
            },
          )
        : Switch(
            value: widget.value,
            onChanged: (value) {
              widget.setState(value);
            },
          );
  }
}
