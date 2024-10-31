import 'package:flutter/material.dart';

class IconCustom extends StatelessWidget {
  const IconCustom({
    Key? key,
    required this.iConURL,
    required this.size,
    this.color,
    this.onPressed,
  }) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  final iConURL;
  final double size;
  final Color? color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Image.asset(
        iConURL,
        width: size,
        height: size,
        color: color,
      ),
    );
  }
}
