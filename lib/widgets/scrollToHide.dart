import 'package:flutter/material.dart';

class ScrolltoHide extends StatefulWidget {
  final Widget child;
  final double height;
  final ScrollController controller;
  final bool isDrawerOpen;
  final Duration duration;

  const ScrolltoHide({
    Key? key,
    required this.child,
    required this.controller,
    required this.height,
    this.duration = const Duration(microseconds: 200),
    required this.isDrawerOpen,
  }) : super(key: key);

  @override
  State<ScrolltoHide> createState() => _ScrolltoHideState();
}

class _ScrolltoHideState extends State<ScrolltoHide> {
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(listen);
    
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(listen);
  }

  void listen() {
    if (widget.controller.position.pixels >= 200 || widget.isDrawerOpen ) {
      hide();
    } else {
      show();
    }
  }

  void show() {
    if (!isVisible) setState(() => isVisible = true);
  }

  void hide() {
    if (isVisible) setState(() => isVisible = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      height: isVisible ? widget.height : 0,
      child: Wrap(
        children: [widget.child],
      ),
    );
  }
}
