import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/common.dart';

class DefaultButton extends StatefulWidget {
  const DefaultButton(
      {Key? key,
      required this.buttonText,
      required this.onPressed,
      this.buttonColor,
      this.textColor,
      this.sizeHeight,
      this.sizeWidth,
      this.borderRadius,
      this.widgetLeft,
      this.widgetRight,
      this.isCustomOnButton,
      this.paddingTop,
      this.borderSide})
      : super(key: key);

  final String buttonText;
  final VoidCallback? onPressed;
  final Color? buttonColor;
  final Color? textColor;
  final double? sizeHeight;
  final double? sizeWidth;
  final double? borderRadius;
  final Widget? widgetLeft;
  final Widget? widgetRight;
  final bool? isCustomOnButton;
  final bool? paddingTop;
  final BorderSide? borderSide;

  @override
  State<DefaultButton> createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    Color foregroundColor =
        Theme.of(context).appBarTheme.iconTheme?.color ?? Colors.white;

    return Padding(
      padding: widget.paddingTop ?? false
          ? EdgeInsets.all(24.w)
          : EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            widget.buttonColor ?? primaryColor,
          ),
          elevation: MaterialStateProperty.all(10),
          minimumSize: MaterialStateProperty.all(Size(
            widget.sizeWidth ?? double.infinity - (5 / 100),
            widget.sizeHeight ?? 54,
          )),
          maximumSize: MaterialStateProperty.all(Size(
            widget.sizeWidth ?? double.infinity - (5 / 100),
            widget.sizeHeight ?? 54,
          )),
          shadowColor: MaterialStateProperty.all<Color>(MyColor.bgDrawerColor),
          side: widget.borderSide != null
              ? MaterialStateProperty.all(widget.borderSide)
              : null,
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 32.0),
            ),
          ),
        ),
        onPressed: widget.onPressed,
        child: Center(
          child: widget.isCustomOnButton == true
              ? Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: widget.widgetLeft!,
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(
                        widget.buttonText.tr().toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: widget.textColor ?? MyColor.textBlack,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: widget.widgetRight!,
                    ),
                  ],
                )
              : Text(
                  widget.buttonText.tr().toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.textColor ?? foregroundColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
