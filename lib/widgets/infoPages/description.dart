import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class Description extends StatelessWidget {
  final String text;
  const Description({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, 0),
      child: Text(
        text,
        style: TextStyle(fontSize: height * 0.015, color: Colors.black87),
      ),
    );
  }
}
