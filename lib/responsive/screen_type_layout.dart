import 'package:flutter/material.dart';
import 'package:keepbilling/enums/device_screen_type.dart';
import 'package:keepbilling/responsive/responsive_builder.dart';

class ScreenTypeLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;

  const ScreenTypeLayout({
    Key? key,
    required this.mobile,
    required this.tablet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.deviceScreenType == DeviceScreenType.Tablet) {
          return tablet;
        }
        return mobile;
      },
    );
  }
}
