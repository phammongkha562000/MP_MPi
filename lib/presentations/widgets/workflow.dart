import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../presentations.dart';

class WorkflowWidget extends StatelessWidget {
  const WorkflowWidget({
    Key? key,
    required this.widgetRight,
    required this.time,
  }) : super(key: key);
  final Widget widgetRight;
  final String time;
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        flex: 1,
        child: DecoratedBox(
            decoration: BoxDecoration(
                border: Border.all(color: MyColor.defaultColor, width: 3),
                shape: BoxShape.circle),
            child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: MyColor.defaultColor, width: 3),
                    shape: BoxShape.circle,
                    color: MyColor.textBlack),
                child: Text(
                  time,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: MyColor.defaultColor),
                ))),
      ),
      Expanded(flex: 4, child: widgetRight),
    ]);
  }
}

RowFlex3and7 itemWorkflow({
  required String textLeft,
  required String textRight,
}) {
  return RowFlex3and7(
    child3: Text(
      textLeft.tr(),
      style: styleLeft(),
    ),
    child7: Text(
      textRight,
      style: styleRight(),
    ),
  );
}

TextStyle styleLeft() {
  return const TextStyle(
    color: MyColor.textBlack,
    letterSpacing: 0.3,
  );
}

TextStyle styleRight() {
  return const TextStyle(
    color: MyColor.textBlack,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.3,
  );
}
