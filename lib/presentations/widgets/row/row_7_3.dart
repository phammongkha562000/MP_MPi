import 'package:flutter/material.dart';

class RowFlex7and3 extends StatelessWidget {
  const RowFlex7and3({
    Key? key,
    required this.child7,
    required this.child3,
  }) : super(key: key);

  final Widget child7;
  final Widget child3;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: child7,
        ),
        Expanded(
          flex: 3,
          child: child3,
        ),
      ],
    );
  }
}
