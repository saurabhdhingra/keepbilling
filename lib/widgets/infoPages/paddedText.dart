import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

class PaddedText extends StatelessWidget {
  final String text;
  const PaddedText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = SizeConfig.getWidth(context);
    var height = SizeConfig.getHeight(context);
    return SizedBox(
      height: height * 0.05,
      child: FittedBox(
        child: Padding(
          padding: EdgeInsets.fromLTRB(width * 0.02, 0, width * 0.02, 0),
          child: Text(
            text,
            style: TextStyle(
                fontSize: height * 0.035,
                fontWeight: FontWeight.w600,
                color: const Color.fromRGBO(91, 95, 255, 1)),
          ),
        ),
      ),
    );
  }
}
