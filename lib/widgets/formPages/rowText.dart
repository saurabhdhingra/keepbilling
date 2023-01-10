import 'package:flutter/material.dart';

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
    return Row(
      children: [
        SizedBox(width: width * 0.05),
        Text(
          text,
          style: style,
        )
      ],
    );
  }
}
