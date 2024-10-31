import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HeaderTableWidget extends StatelessWidget {
  const HeaderTableWidget({super.key, required this.headerText});
  final String headerText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Text(
        headerText.tr(),
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 14, color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
  }
}
