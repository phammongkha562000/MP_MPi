import 'package:flutter/material.dart';
import '/presentations/presentations.dart';

class RowFlex4and6 extends StatelessWidget {
  const RowFlex4and6({
    Key? key,
    required this.child4,
    required this.child6,
    this.widthSpacer,
  }) : super(key: key);

  final Widget child4;
  final Widget child6;
  final bool? widthSpacer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: child4,
        ),
        widthSpacer == true ? const WidthSpacer(width: 0.02) : const SizedBox(),
        Expanded(
          flex: 6,
          child: child6,
        ),
      ],
    );
  }
}
