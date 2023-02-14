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
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.06,
        vertical: height * 0.01,
      ),
      child: Row(
        children: [
          SizedBox(
            height: height * 0.03,
            child: FittedBox(
              child: Text(
                "$title : ",
                style: TextStyle(
                  fontSize: height * 0.025,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.03,
            child: FittedBox(
              child: Text(
                info,
                style: TextStyle(
                  fontSize: height * 0.022,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
