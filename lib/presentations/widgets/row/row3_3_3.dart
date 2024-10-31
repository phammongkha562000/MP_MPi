import 'package:flutter/material.dart';

class RowFlex333 extends StatelessWidget {
  const RowFlex333({
    Key? key,
    this.child1,
    this.child2,
    this.child3,
  }) : super(key: key);

  final Widget? child1;
  final Widget? child2;
  final Widget? child3;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: child1 ?? const SizedBox(),
        ),
        Expanded(
          flex: 3,
          child: child2 ?? const SizedBox(),
        ),
        Expanded(
          flex: 3,
          child: child3 ?? const SizedBox(),
        ),
      ],
    );
  }
}
