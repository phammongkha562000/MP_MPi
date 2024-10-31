import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../common/assets.dart';

class IconApprove extends StatelessWidget {
  const IconApprove({super.key, required this.isApprove, this.onPressed});
  final bool isApprove;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        tooltip: isApprove ? 'approval'.tr() : 'reject'.tr(),
        icon: Image.asset(isApprove ? MyAssets.approve : MyAssets.reject,
            width: 32),
        onPressed: onPressed);
  }
}
