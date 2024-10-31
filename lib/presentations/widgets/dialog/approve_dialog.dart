import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../presentations.dart';

class ApproveDialog extends StatefulWidget {
  const ApproveDialog(
      {Key? key,
      required this.controller,
      required this.onPressed,
      required this.isApprove,
      this.formKey})
      : super(key: key);
  final TextEditingController controller;
  final void Function() onPressed;
  final bool isApprove;
  final Key? formKey;

  @override
  State<ApproveDialog> createState() => _ApproveDialogState();
}

class _ApproveDialogState extends State<ApproveDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: <Widget>[
          Text(
            widget.isApprove
                ? "approve".tr().toUpperCase()
                : "reject".tr().toUpperCase(),
            style: TextStyle(
                color: widget.isApprove ? Colors.blue : Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Form(
        key: widget.formKey,
        child: TextFormField(
            autofocus: true,
            controller: widget.controller,
            validator: widget.isApprove
                ? null
                : (value) {
                    if (value!.isEmpty) {
                      return "approvalcommentvalid".tr();
                    }
                    return null;
                  },
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  widget.controller.clear();
                },
                icon: const Icon(
                  Icons.close,
                  color: MyColor.textRed,
                ),
              ),
              hintText: "comment".tr(),
            )),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text("close".tr()),
        ),
        TextButton(onPressed: widget.onPressed, child: Text("update".tr())),
      ],
    );
  }
}
