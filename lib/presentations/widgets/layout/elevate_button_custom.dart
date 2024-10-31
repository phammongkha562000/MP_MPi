import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:mpi_new/presentations/presentations.dart';

class ElevateButtonCustom extends StatefulWidget {
  const ElevateButtonCustom(
      {super.key,
      required this.onPressed,
      required this.text,
      this.child,
      this.width,
      this.enable});
  final VoidCallback onPressed;
  final String text;
  final double? width;
  final Widget? child;
  final bool? enable;

  @override
  State<ElevateButtonCustom> createState() => _ElevateButtonCustomState();
}

class _ElevateButtonCustomState extends State<ElevateButtonCustom> {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    Color foregroundColor =
        Theme.of(context).appBarTheme.iconTheme?.color ?? Colors.white;

    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
      child: ElevatedButton(
          style: ButtonStyle(
              minimumSize:
                  MaterialStateProperty.all(Size(widget.width ?? 200, 50)),
              maximumSize: MaterialStateProperty.all(Size(
                widget.width ?? double.infinity,
                50,
              )),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24))),
              elevation: MaterialStateProperty.all(5),
              shadowColor: MaterialStateProperty.all(MyColor.pastelGray),
              backgroundColor: MaterialStateProperty.all(
                  widget.enable ?? true ? primaryColor : MyColor.pastelGray)),
          onPressed: widget.enable ?? true ? widget.onPressed : null,
          child: widget.child ??
              Text(
                widget.text.tr().toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.enable ?? true
                        ? foregroundColor
                        : MyColor.outerSpace),
              )),
    );
  }
}
