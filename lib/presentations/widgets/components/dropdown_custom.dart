import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

bool isExpanded = true;
InputDecoration inputDecoration =
    const InputDecoration(isDense: true, contentPadding: EdgeInsets.zero);
ButtonStyleData buttonStyleData = const ButtonStyleData(height: 48);

MenuItemStyleData menuItemStyleData =
    MenuItemStyleData(selectedMenuItemBuilder: (context, child) {
  return ColoredBox(
    color: Theme.of(context).primaryColor.withOpacity(0.2),
    child: child,
  );
});

DropdownStyleData dropdownStyleData = DropdownStyleData(
  elevation: 8,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
  ),
  scrollbarTheme: ScrollbarThemeData(
    radius: const Radius.circular(50),
    thickness: MaterialStateProperty.all(6),
    thumbVisibility: MaterialStateProperty.all(true),
  ),
  maxHeight: 300,
);
