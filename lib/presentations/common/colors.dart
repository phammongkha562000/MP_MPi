import 'package:flutter/material.dart';

class MyColor {
  static const defaultColor = Color(0xffffc700); //ffcc31
  // static const defaultColor = Colors.red; //ffcc31
  static const blanchedAlmond = Color(0xffFFF2CC);
  static const cosmicLatte = Color(0xffFFFBEB);

//Drawer
  static const bgDrawerColor = Color.fromARGB(225, 226, 230, 242);
  static const itemDrawerColor = Colors.white;
  static const colorInput = Color.fromARGB(255, 233, 227, 227);

//textColor
  static const textBlack = Colors.black;
  static const textWhite = Colors.white;
  static const textRed = Colors.red;
  static const textGrey = Colors.grey;
  static const textDarkBlue = Color.fromRGBO(50, 63, 101, 1);
  static const textGreen = Color.fromARGB(255, 22, 154, 90);
  static const textAmber = Colors.amber;
  static const textBlue = Color.fromARGB(255, 11, 132, 231);

//button disable
  static const btnGreyDisable = Colors.grey;
  static const whiteSmoke = Color(0x66f5f5f5);

  static const americanYellow = Color(0xffeeb303);
  static const btnGreen = Color.fromARGB(255, 25, 121, 75);

//toast
  static const success = Color.fromARGB(255, 172, 245, 188);
  static const warning = Colors.yellow;
  static const error = Colors.red;

  static const warningColor = Color(0xffff6b00);

  static const platinum = Color(0xffE7E7E7);
  static const darkLiver = Color(0xFF4e4e4e);
  static const outerSpace = Color(0xFF4A4A48);

  static const pastelGray = Color(0xffCDC9C3);
  static const seashell = Color(0xffFBF7F0);
  static const transparent = Colors.transparent;
  static const aliceBlue = Color(0xffECF2FF);
  static const aliceBlue2 = Color.fromARGB(255, 214, 237, 251);

  static const colorBottom = Color(0xffF8F8F8);
  static const paleGoldenrod = Color(0xffF4F1B0);
  static const buttonBlue = Color(0xffB9F3FC);
  static const nokiaBlue = Color(0xff005AFF);

//clockinout
  static const sapGreen = Color(0xff518234);
  static const greenRYB = Color(0xff67C033);
  static const frenchBistre = Color(0xff846d4e);
  static const lightFrenchBeige = Color(0xffc9a578);

// F8F8F8
  static const dartCustom = Color(0x0021222d);
  static int getColorHexFromStr(String colorStr) {
    colorStr = "FF$colorStr";
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;

    for (int i = 0; i < len; i++) {
      int hexDigit = colorStr.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      }
    }
    return val;
  }

  static Color getColor(String colorStr) {
    return Color(getColorHexFromStr(colorStr));
  }

  static Color getColorByroom(String facilityCode) {
    //return Colors.grey;
    switch (facilityCode) {
      case 'MPH1F001':
        return Color(getColorHexFromStr('#FDF1BA'));

      case 'MPH1F002':
        return Color(getColorHexFromStr('#f45b69'));

      case 'MPH3F001':
        return Color(getColorHexFromStr('#337ab7'));

      case 'MPH4F001':
        return Color(getColorHexFromStr('#FDC82F'));

      case 'MPH1F003':
        return Colors.pinkAccent;

      case 'MPD1F001':
        return Colors.grey;

      case 'MPP1F001':
        return Colors.redAccent;
      case 'MPP6F001':
        return Color(getColorHexFromStr('#71c9ea'));
      case 'MPP6F002':
        return Color(getColorHexFromStr('#2ec4b6'));
      default:
        return Colors.grey;
    }
  }

  static Color getTextColor() {
    return Color(getColorHexFromStr("#4d4d4f"));
  }
}
