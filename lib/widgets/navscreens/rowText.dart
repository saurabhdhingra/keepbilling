import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keepbilling/responsive/screen_type_layout.dart';
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
    return ScreenTypeLayout(
      mobile: Row(
        children: [
          SizedBox(width: width * 0.04),
          SizedBox(
            width: width * 0.72,
            child: Text(
              text,
              textAlign: TextAlign.start,
              style: GoogleFonts.mukta(
                color: color,
                fontSize: width * 0.055,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      tablet: Row(
        children: [
          SizedBox(width: width * 0.04),
          SizedBox(
            width: width * 0.72,
            child: Text(
              text,
              textAlign: TextAlign.start,
              style: GoogleFonts.mukta(
                color: color,
                fontSize: width * 0.04,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
