import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mpi_new/presentations/common/colors.dart';

class ContainerPanelColor extends StatelessWidget {
  const ContainerPanelColor({super.key, required this.text, this.isRight});
  final String text;
  final bool? isRight;
  @override
  Widget build(BuildContext context) {
    Color backgroundPanel = Theme.of(context).colorScheme.onPrimaryContainer;
    Color colorPanel =
        Theme.of(context).textTheme.titleSmall?.color ?? MyColor.defaultColor;
    return Container(
        padding: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 6.h),
        decoration: BoxDecoration(
            color: backgroundPanel,
            borderRadius: isRight ?? false
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(32.r),
                    topLeft: Radius.circular(32.r),
                  )
                : BorderRadius.only(
                    bottomRight: Radius.circular(32.r),
                    topRight: Radius.circular(32.r),
                  )),
        child: Text(
          text,
          style: TextStyle(
            color: colorPanel,
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}
