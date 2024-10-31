import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mpi_new/presentations/presentations.dart';

import '../common/colors.dart';

class CardCustom extends StatelessWidget {
  const CardCustom({
    Key? key,
    required this.child,
    this.margin,
  }) : super(key: key);

  final Widget child;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin ?? EdgeInsets.all(8.w),
      shadowColor: MyColor.textGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      elevation: 10,
      child: child,
    );
  }
}
