import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class Description extends StatelessWidget {
  final String property;
  final String value;
  const Description({Key? key, required this.value, required this.property})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, 0),
      child: RichText(
        text: TextSpan(
            text: property,
            style: TextStyle(
                fontSize: height * 0.015,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                  text: value,
                  style: TextStyle(
                      fontSize: height * 0.015,
                      color: Colors.black87,
                      fontWeight: FontWeight.normal))
            ]),
      ),
    );
  }
}
