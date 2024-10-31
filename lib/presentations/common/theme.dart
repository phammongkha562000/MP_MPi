import 'package:flutter/material.dart';

import 'colors.dart';

ThemeData theme({
  required Color primaryColor,
  required Color secondaryColor,
  required Color dividerColor,
  required Color surfaceColor,
  required Color frameFontColor,
  required Color normalFontColor,
  required Color appbarColor,
  required Color backgroundPanel,
  required Color colorPanel,
}) {
  return ThemeData(
      fontFamily: "Lato",
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: secondaryColor,
        selectionHandleColor: secondaryColor,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: normalFontColor),
        displayMedium: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.w600,
            color: normalFontColor),
        displaySmall: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
            color: normalFontColor),
        bodyLarge: TextStyle(fontSize: 16.0, color: normalFontColor),
        bodySmall: TextStyle(fontSize: 12.0, color: normalFontColor),
        titleSmall: TextStyle(
            fontSize: 16.0, color: colorPanel, fontWeight: FontWeight.w800),
      ),
      appBarTheme: appBarTheme(bgColor: appbarColor, iconColor: frameFontColor),
      switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.all(secondaryColor),
          trackColor:
              MaterialStateProperty.all(secondaryColor.withOpacity(0.5))),
      inputDecorationTheme: _inputDecoration(
          fillColor: primaryColor.withOpacity(0.1), appbarColor: appbarColor),
      bottomNavigationBarTheme: bottomNavigationBarThemeData(),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              textStyle: TextStyle(color: frameFontColor),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              backgroundColor: appbarColor)),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              textStyle:
                  MaterialStateProperty.all(TextStyle(color: frameFontColor)))),
      dividerTheme: DividerThemeData(color: dividerColor, thickness: 0.3),
      cardTheme: CardTheme(surfaceTintColor: surfaceColor),
      primarySwatch: getMaterialColor(primaryColor),
      primaryColor: appbarColor,
      colorScheme: ColorScheme.light(
        surface: surfaceColor,
        primary: secondaryColor,
        onPrimaryContainer: backgroundPanel,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: appbarColor,
          foregroundColor: frameFontColor,
          extendedTextStyle: const TextStyle(fontWeight: FontWeight.bold)));
}

InputDecorationTheme _inputDecoration(
    {required Color fillColor, required Color appbarColor}) {
  var border = OutlineInputBorder(
      borderSide: BorderSide.none, borderRadius: BorderRadius.circular(32));
  return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      prefixIconColor: appbarColor,
      suffixIconColor: appbarColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
      border: border,
      labelStyle: const TextStyle(color: Colors.grey));
}

MaterialColor getMaterialColor(Color color) {
  const Map<int, Color> shades = {
    50: Color.fromRGBO(78, 78, 78, .1),
    100: Color.fromRGBO(78, 78, 78, .2),
    200: Color.fromRGBO(78, 78, 78, .3),
    300: Color.fromRGBO(78, 78, 78, .4),
    400: Color.fromRGBO(78, 78, 78, .5),
    500: Color.fromRGBO(78, 78, 78, .6),
    600: Color.fromRGBO(78, 78, 78, .7),
    700: Color.fromRGBO(78, 78, 78, .8),
    800: Color.fromRGBO(78, 78, 78, .9),
    900: Color.fromRGBO(78, 78, 78, 1)
  };
  return MaterialColor(color.value, shades);
}

AppBarTheme appBarTheme({required Color bgColor, required Color iconColor}) {
  return AppBarTheme(
      backgroundColor: bgColor,
      elevation: 0,
      titleTextStyle: TextStyle(
          color: iconColor, fontSize: 14, fontWeight: FontWeight.bold),
      centerTitle: true,
      iconTheme: IconThemeData(color: iconColor));
}

BottomNavigationBarThemeData bottomNavigationBarThemeData() {
  return BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: MyColor.defaultColor,
      showUnselectedLabels: false,
      selectedIconTheme: const IconThemeData(color: MyColor.defaultColor),
      selectedLabelStyle: selectedLabelStyle());
}

TextStyle selectedLabelStyle() {
  return const TextStyle(fontWeight: FontWeight.bold, fontSize: 15);
}
