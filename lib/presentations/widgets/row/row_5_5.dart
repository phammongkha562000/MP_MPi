import 'package:flutter/material.dart';
import '/presentations/presentations.dart';

class RowFlex5and5 extends StatelessWidget {
  const RowFlex5and5({
    Key? key,
    required this.left,
    this.spacer,
    required this.right,
    this.widthSpacer,
    this.crossAxisAlignment,
  }) : super(key: key);

  final Widget left;
  final Widget right;
  final bool? spacer;
  final double? widthSpacer;
  final CrossAxisAlignment? crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: left,
        ),
        spacer == true
            ? WidthSpacer(width: widthSpacer ?? 0.02)
            : const SizedBox(),
        Expanded(
          flex: 5,
          child: right,
        ),
      ],
    );
  }
}
