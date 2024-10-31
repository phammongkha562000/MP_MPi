import 'package:flutter/material.dart';
import '/presentations/presentations.dart';

class RowFlex6and4 extends StatelessWidget {
  const RowFlex6and4({
    Key? key,
    required this.child6,
    required this.child4,
    this.widthSpacer,
  }) : super(key: key);

  final Widget child6;
  final Widget child4;
  final bool? widthSpacer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: child6,
        ),
        widthSpacer == true ? const WidthSpacer(width: 0.02) : const SizedBox(),
        Expanded(
          flex: 4,
          child: child4,
        ),
      ],
    );
  }
}
