import 'package:flutter/material.dart';
import 'package:keepbilling/responsive/screen_type_layout.dart';

import '../../../utils/constants.dart';

class RowText extends StatelessWidget {
  final String text;
  final TextStyle style;
  const RowText({
    Key? key,
    required this.text,
    this.style = const TextStyle(
        color: Colors.black87, fontWeight: FontWeight.w700, fontSize: 16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = SizeConfig.getWidth(context);
    var height = SizeConfig.getHeight(context);
    return ScreenTypeLayout(
      mobile: SizedBox(
        height: height * 0.025,
        child: FittedBox(
          child: Padding(
            padding: EdgeInsets.fromLTRB(width * 0.04, 0, width * 0.02, 0),
            child: Text(
              text,
              style: style,
            ),
          ),
        ),
      ),
      tablet: SizedBox(
        height: height * 0.025,
        child: FittedBox(
          child: Padding(
            padding: EdgeInsets.fromLTRB(width * 0.05, 0, 0, 0),
            child: Text(
              text,
              style: style,
            ),
          ),
        ),
      ),
    );
  }
}
