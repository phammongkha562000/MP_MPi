import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../presentations.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "loading".tr(),
                style: MyStyle.styleTextTitle,
              ),
              const WidthSpacer(width: 0.02),
              const SpinKitCircle(
                color: MyColor.defaultColor,
                // size: 30,
              )
            ],
          ),
          const HeightSpacer(height: 0.02)
        ],
      ),
    );
  }
}
