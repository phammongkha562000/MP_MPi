import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icons/empty.webp",
            width: MediaQuery.sizeOf(context).width * 0.5,
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
          Text(
            "nodata".tr().toUpperCase(),
            style: const TextStyle(
              fontSize: 15,
              color: Color.fromARGB(126, 100, 100, 100),
            ),
          )
        ],
      ),
    );
  }
}
