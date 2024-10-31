import 'package:flutter/material.dart';
import '../../common/colors.dart';
import '/presentations/widgets/widgets.dart';
import 'package:shimmer/shimmer.dart';

class ItemLoading extends StatelessWidget {
  const ItemLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Shimmer.fromColors(
        baseColor: MyColor.bgDrawerColor,
        highlightColor: MyColor.textGrey,
        child: ListView.builder(
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 20,
          itemBuilder: (context, index) {
            return const Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 75,
                      width: 75,
                      child: Card(),
                    ),
                  ),
                  WidthSpacer(width: 0.01),
                  Expanded(
                    flex: 8,
                    child: Column(
                      children: [
                        Divider(
                          color: MyColor.textGrey,
                          thickness: 2,
                        ),
                        Divider(
                          color: MyColor.bgDrawerColor,
                          thickness: 2,
                        ),
                        Divider(
                          color: MyColor.textGrey,
                          thickness: 2,
                        ),
                        Divider(
                          color: MyColor.bgDrawerColor,
                          thickness: 2,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
