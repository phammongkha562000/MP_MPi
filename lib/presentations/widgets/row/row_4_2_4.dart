import 'package:flutter/material.dart';

class RowFlex424 extends StatelessWidget {
  const RowFlex424({
    Key? key,
    required this.left,
    required this.right,
    required this.mid,
  }) : super(key: key);

  final Widget left;
  final Widget right;
  final Widget mid;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: left,
        ),
        Expanded(
          flex: 2,
          child: mid,
        ),
        Expanded(
          flex: 4,
          child: right,
        ),
      ],
    );
  }
}
