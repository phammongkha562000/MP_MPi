
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mpi_new/presentations/common/colors.dart';

class TextRichRequired extends StatelessWidget {
  const TextRichRequired({super.key, required this.label, this.colorText});
final String label;
final Color? colorText;
  @override
  Widget build(BuildContext context) {
    return    Text.rich(TextSpan(children: [
      TextSpan(text: label.tr(),  style: TextStyle(color: colorText?? Colors.black, fontWeight: FontWeight.bold)),
      const TextSpan(
          text: ' *',
          style: TextStyle(color: MyColor.textRed, fontWeight: FontWeight.bold)),
    ]));
  }
}