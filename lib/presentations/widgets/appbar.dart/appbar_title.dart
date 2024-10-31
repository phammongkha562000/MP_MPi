import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppbarTitle extends StatelessWidget {
  const AppbarTitle({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title.tr().toUpperCase());
  }
}
