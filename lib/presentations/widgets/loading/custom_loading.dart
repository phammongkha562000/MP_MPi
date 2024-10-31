import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../common/colors.dart';

class LoadingCustom extends StatelessWidget {
  const LoadingCustom({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Shimmer.fromColors(
        baseColor: MyColor.bgDrawerColor,
        highlightColor: MyColor.textGrey,
        child: Center(child: widget),
      ),
    );
  }
}
