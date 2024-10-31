import 'package:flutter/material.dart';

import '../../presentations.dart';

class LoadingProfile extends StatelessWidget {
  const LoadingProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingCustom(
      widget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const CircleAvatar(radius: 55),
            const HeightSpacer(height: 0.01),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return const ListTile(
                    leading: Icon(Icons.label_important_rounded),
                    title: Divider(
                      thickness: 20,
                      color: MyColor.textBlack,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
