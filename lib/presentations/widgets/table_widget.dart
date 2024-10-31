import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../common/colors.dart';

class BuildHeaderTable extends StatelessWidget {
  const BuildHeaderTable({super.key, required this.headerText});
  final String headerText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        headerText.tr(),
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: MyColor.outerSpace, fontWeight: FontWeight.w700),
      ),
    );
  }
}
