import 'package:flutter/material.dart';
import 'package:sapphireui/functions/root.dart';

class CellWrapper extends StatelessWidget {
  const CellWrapper({
    super.key,
    required this.child,
    this.minHeight = 50,
    this.backgroundColor,
    this.borderRadius = 10,
    this.horizontalPadding = 16,
  });
  final Widget child;
  final double minHeight;
  final Color? backgroundColor;
  final double borderRadius;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? CustomColors.cellColor(context),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: minHeight, minWidth: double.infinity),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Center(child: child),
        ),
      ),
    );
  }
}
