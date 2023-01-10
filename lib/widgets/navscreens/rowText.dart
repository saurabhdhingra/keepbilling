import 'package:flutter/material.dart';
import 'package:keepbilling/utils/constants.dart';

class RowText extends StatelessWidget {
  final String text;
  final Color color;

  const RowText({
    Key? key,
    required this.text,
    this.color = const Color(0xFF4CAF50),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = SizeConfig.getWidth(context);
    return Row(
      children: [
        SizedBox(width: width * 0.04),
        SizedBox(
          width: width * 0.72,
          child: Text(
            text,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: color,
              fontSize: width * 0.055,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
