import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

class TitleText extends StatelessWidget {
  final String text;
  const TitleText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    return SizedBox(
      height: height * 0.07,
      child: FittedBox(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              width * 0.02, height * 0.01, width * 0.02, height * 0.01),
          child: Text(
            text,
            style: TextStyle(
                fontSize: height * 0.04,
                fontWeight: FontWeight.w800,
                color:const Color.fromRGBO(91, 95, 255, 1)),
          ),
        ),
      ),
    );
  }
}
