import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/constants.dart';

class QuickLink extends StatefulWidget {
  final String text;
  final Widget screen;
  final VoidCallback? function;
  final bool isButton;
  final IconData icon;

  const QuickLink({
    Key? key,
    required this.text,
    required this.screen,
    required this.isButton,
    this.function,
    required this.icon,
  }) : super(key: key);

  @override
  State<QuickLink> createState() => _QuickLinkState();
}

class _QuickLinkState extends State<QuickLink> {
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
            horizontal: width * 0.05, vertical: height * 0.01),
        child: Container(
          height: height * 0.08,
          width: width * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(height * 0.02),
            ),
          ),
          child: Center(
            child: Row(
              children: [
                SizedBox(width: width * 0.03),
                Icon(widget.icon),
                SizedBox(width: width * 0.03),
                SizedBox(
                  width: width * 0.7,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: width * 0.05,
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
