import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/constants.dart';

class QuickLinkGrid extends StatefulWidget {
  final String text;
  final Widget screen;
  final VoidCallback? function;
  final bool isButton;
  final bool isTablet;
  final IconData icon;

  const QuickLinkGrid({
    Key? key,
    required this.text,
    required this.screen,
    required this.isButton,
    this.function,
    required this.icon,
    required this.isTablet,
  }) : super(key: key);

  @override
  State<QuickLinkGrid> createState() => _QuickLinkGridState();
}

class _QuickLinkGridState extends State<QuickLinkGrid> {
  @override
  Widget build(BuildContext context) {
    var height = SizeConfig.getHeight(context);
    var width = SizeConfig.getWidth(context);
    return GestureDetector(
      onTap: () {
        if (!widget.isButton) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => widget.screen),
          );
        } else {
          widget.function!();
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.005, vertical: height * 0.002),
        child: Container(
          height: height * 0.07,
          width: width * 0.4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(height * 0.02),
            ),
          ),
          child: Center(
            child: Row(
              children: [
                SizedBox(width: width * 0.028),
                Icon(
                  widget.icon,
                  size: widget.isTablet ? width * 0.035 : null,
                ),
                SizedBox(width: width * 0.028),
                SizedBox(
                  width: width * 0.3,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.mukta(
                        fontSize: widget.isTablet ? width * 0.03 : width * 0.04,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
