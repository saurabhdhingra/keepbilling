import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

class PaddedText extends StatelessWidget {
  final String text;
  final TextStyle style;
  const PaddedText({Key? key, required this.text, required this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = SizeConfig.getWidth(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(width * 0.03, 0, 0, 0),
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
