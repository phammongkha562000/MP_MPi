import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mpi_new/presentations/common/colors.dart';

class LayoutCustom {
  static EdgeInsets contentPaddingTFF = const EdgeInsets.symmetric(
      vertical: 8, horizontal: 12); //contentPadding of textformfield-textfield
  static EdgeInsets paddingView =
      const EdgeInsets.fromLTRB(16, 16, 16, 0); // padding of view
  static EdgeInsets paddingItemView = EdgeInsets.symmetric(
      vertical: 4.h, horizontal: 8.w); // padding between widget in view
  static EdgeInsets paddingItemCard = EdgeInsets.symmetric(
      horizontal: 8.w, vertical: 8.h); // padding between content vs card

  static EdgeInsets paddingVerticalItemView =
      EdgeInsets.symmetric(vertical: 6.h); // padding between widget in view
  static EdgeInsets paddingBottomListView =
      EdgeInsets.only(bottom: 100.h); // padding between content vs card
  static EdgeInsets paddingDateTimePicker = EdgeInsets.all(16.w);
  static BoxDecoration decorationDropdown = BoxDecoration(
      borderRadius: BorderRadius.circular(32),
      color: Colors.white,
      boxShadow: const [
        BoxShadow(
          color: MyColor.pastelGray,
          blurRadius: 10.0,
          spreadRadius: 1.0,
          offset: Offset(
            5.0,
            5.0,
          ),
        ),
      ]);
  static List<BoxShadow> boxShadow = [
    BoxShadow(
      color: MyColor.pastelGray.withOpacity(0.5),
      spreadRadius: 5,
      blurRadius: 7,
      offset: const Offset(0, 3),
    ),
  ];
  static TextStyle hintStyle =
      TextStyle(fontSize: 14, color: MyColor.outerSpace.withOpacity(0.5));

  static TextStyle labelStyleRequired =
      const TextStyle(fontWeight: FontWeight.bold, color: Colors.black);

  static BorderRadius borderRadiusRight12 = BorderRadius.only(
    topRight: Radius.circular(12.r),
    bottomRight: Radius.circular(12.r),
  );
  static BorderRadius borderRadiusLeft32 = BorderRadius.only(
    topLeft: Radius.circular(32.r),
    bottomLeft: Radius.circular(32.r),
  );
  // static ButtonStyleData btnStyleDropdown = const ButtonStyleData(height: 48);
  // static Color colorSelectDropdown = MyColor.colorInput;
}
