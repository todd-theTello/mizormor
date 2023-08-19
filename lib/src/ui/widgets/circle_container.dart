import 'package:flutter/material.dart';

///
class CircleContainer extends StatelessWidget {
  ///
  const CircleContainer({
    super.key,
    Color? color,
    Widget? child,
    EdgeInsetsGeometry? padding,
  })  : _color = color,
        _child = child,
        _padding = padding;
  final Color? _color;
  final Widget? _child;
  final EdgeInsetsGeometry? _padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: _color,
        shape: BoxShape.circle,
      ),
      child: _child,
    );
  }
}
