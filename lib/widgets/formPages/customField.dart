import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepbilling/responsive/screen_type_layout.dart';
import '../../../utils/constants.dart';

class CustomField extends StatefulWidget {
  final Function(String) setValue;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final GlobalKey<FormState> formKey;
  final bool obscureText;
  final String? initialValue;
  final String? hintText;
  final int? maxLines;
  final List<TextInputFormatter>? textFormatters;
  final TextEditingController? controller;

  final bool readOnly;

  const CustomField({
    Key? key,
    required this.setValue,
    required this.formKey,
    this.obscureText = false,
    this.keyboardType = TextInputType.visiblePassword,
    this.validator,
    this.initialValue,
    this.controller,
    this.readOnly = false,
    this.hintText,
    this.maxLines = 1,
    this.textFormatters,
  }) : super(key: key);

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  @override
  Widget build(BuildContext context) {
    var width = SizeConfig.getWidth(context);
    var height = SizeConfig.getHeight(context);

    return ScreenTypeLayout(
      mobile: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: formChild(height)),
      tablet: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.1),
        child: formChild(height),
      ),
    );
  }

  Form formChild(height) {
    return Form(
      key: widget.formKey,
      child: TextFormField(
        maxLines: widget.maxLines,
        readOnly: widget.readOnly,
        controller: widget.controller,
        initialValue: widget.initialValue,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        cursorColor: Colors.black,
        inputFormatters: widget.textFormatters,
        style: TextStyle(fontSize: height * 0.018),
        onChanged: (value) {
          widget.setValue(value);
        },
        decoration: InputDecoration(
            filled: true,
            fillColor: Platform.isIOS
                ? const Color.fromRGBO(235, 235, 235, 1)
                : Colors.white,
            border: Platform.isIOS
                ? const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10)))
                : const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: widget.hintText),
        obscureText: widget.obscureText,
      ),
    );
  }
}
