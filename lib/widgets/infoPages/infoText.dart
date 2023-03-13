import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class InfoText extends StatelessWidget {
  final String title;
  final String info;
  const InfoText({Key? key, required this.title, required this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(width * 0.06, height * 0.01, 0, 0),
      child: SizedBox(
        height: height * 0.03,
        child: FittedBox(
          child: RichText(
            text: TextSpan(
              text: "$title : ",
              style: TextStyle(
                fontSize: height * 0.025,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              children: [
                TextSpan(
                  text: info,
                  style: TextStyle(
                    fontSize: height * 0.02,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
