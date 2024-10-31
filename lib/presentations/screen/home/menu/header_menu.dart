import 'package:flutter/material.dart';

import '../../../presentations.dart';

class HeaderMenu extends StatelessWidget {
  const HeaderMenu({
    Key? key,
    required this.serverMode,
    required this.empName,
    required this.linkAvt,
  }) : super(key: key);

  final String serverMode;
  final String empName;
  final String linkAvt;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/layout_bg.png"),
                fit: BoxFit.cover)),
        child: Center(
            child: Column(children: [
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.sizeOf(context).height * 0.05)),
          AvtCustom(linkAvt: linkAvt, fullName: empName),
          const HeightSpacer(height: 0.01),
          const Text("Minh Phuong Logistics",
              style: TextStyle(
                  color: MyColor.defaultColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold)),
          const HeightSpacer(height: 0.01),
          Text(empName, style: MyStyle.styleDefaultText),
          const HeightSpacer(height: 0.02)
        ])));
  }
}
