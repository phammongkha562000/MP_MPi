import 'package:flutter/material.dart';

class RowFlex3and7 extends StatelessWidget {
  const RowFlex3and7({
    Key? key,
    required this.child3,
    required this.child7,
  }) : super(key: key);

  final Widget child3;
  final Widget child7;

  @override
  Widget build(BuildContext context) {
    return Row(
  crossAxisAlignment: CrossAxisAlignment.baseline,
  textBaseline: TextBaseline.ideographic,
      children: [
        Expanded(
          flex: 3,
          child: child3,
        ),
        Expanded(
          flex: 7,
          child: child7,
        ),
      ],
    );
  }
}
