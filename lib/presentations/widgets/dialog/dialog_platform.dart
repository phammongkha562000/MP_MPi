// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformDialog {
  static showConfirmDialog(BuildContext context,
          {required VoidCallback onOk,
          required String text,
          required String btnOkText}) =>
      Platform.isIOS
          ? showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: Text("confirm".tr()),
                content: Text(text.tr()),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("close".tr()),
                  ),
                  CupertinoDialogAction(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onOk();
                    },
                    child: Text(
                      btnOkText.tr(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ),
                ],
              ),
            )
          : showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                    title: Text("confirm".tr()),
                    content: Text(text.tr()),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("close".tr()),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onOk();
                        },
                        child: Text(
                          btnOkText.tr(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ),
                    ],
                  ));
}
