import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppBarCustom extends AppBar {
  AppBarCustom(
    BuildContext context, {
    Key? key,
    String? title,
    Function? onPressBack,
    List<Widget>? actionRight,
  }) : super(
            key: key,
            title: Text("$title".tr().toUpperCase()),
            leading: IconButton(
              onPressed: onPressBack == null
                  ? () {
                      Navigator.pop(context);
                    }
                  : onPressBack as void Function()?,
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
            actions: actionRight);
}
