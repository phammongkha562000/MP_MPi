import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/data.dart';

final isValidateNewPassword = ValueNotifier<bool>(false);

class ValidatePasswordWidget extends StatefulWidget {
  const ValidatePasswordWidget({
    Key? key,
    required this.controller,
    this.minCharacter,
  }) : super(key: key);

  final TextEditingController controller;
  final int? minCharacter;

  @override
  State<ValidatePasswordWidget> createState() =>
      _ValidatePasswordMaterialState();
}

class _ValidatePasswordMaterialState extends State<ValidatePasswordWidget> {
  int strength = 0;
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    final password = widget.controller.text;
    final maxLength = widget.minCharacter ?? 6;
    setState(() {
      strength = calculatePasswordStrength(
        password: password,
        minCharacter: maxLength,
      );
      if (strength == 5) {
        isValidateNewPassword.value = true;
      } else {
        isValidateNewPassword.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String inputText = widget.controller.text;

    String minCharacter =
        widget.minCharacter == null ? "6" : widget.minCharacter.toString();

    Color checkInputValidity(
        {required String inputText, required String pattern}) {
      final hasMatch = RegExp(pattern).hasMatch(inputText);
      return hasMatch ? MyColor.textGreen : MyColor.textGrey;
    }

    Color check1 = checkInputValidity(
        inputText: inputText, pattern: '^[^\\s]{$minCharacter,}\$');
    Color check2 = checkInputValidity(inputText: inputText, pattern: r'[A-Z]');
    Color check3 = checkInputValidity(inputText: inputText, pattern: r'[a-z]');
    Color check4 = checkInputValidity(inputText: inputText, pattern: r'\d');
    Color check5 = checkInputValidity(
        inputText: inputText, pattern: r'[!@#\$&*~%^()|,.;:?/<>]');

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: LinearProgressIndicator(
            value: strength / 5,
            backgroundColor: Colors.grey[200],
            valueColor: strength < 2
                ? const AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 255, 17, 0))
                : strength < 3
                    ? const AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 255, 153, 0))
                    : strength < 4
                        ? const AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(255, 230, 209, 27))
                        : const AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        ),
        Column(
          children: [
            textCheck(
              text:
                  "${"at_least".tr()} ${widget.minCharacter ?? 6} ${"character".tr()} (a2b4c6)",
              check: check1,
            ),
            textCheck(
              text: "${"uppercase_character".tr()} (A,B,...)",
              check: check2,
            ),
            textCheck(
              text: "${"normal_character".tr()} (a,b,...)",
              check: check3,
            ),
            textCheck(
              text: "${"number_character".tr()} (1,2,...)",
              check: check4,
            ),
            textCheck(
              text: "${"special_character".tr()} (!@#\$&*~%^()|,.;:?/<>)",
              check: check5,
            ),
          ],
        ),
      ],
    );
  }

  Widget textCheck({
    required String text,
    required Color check,
  }) {
    return Row(
      children: [
        Icon(
          Icons.task_alt,
          color: check,
        ),
        const WidthSpacer(width: 0.01),
        Text(
          text,
          style: TextStyle(color: check),
        )
      ],
    );
  }

  int calculatePasswordStrength({
    required String password,
    int? minCharacter,
  }) {
    int strength = 0;

    if (password.contains(RegExp('^[^\\s]{$minCharacter,}\$'))) {
      strength++;
    }

    if (password.contains(RegExp(r'[A-Z]'))) {
      strength++;
    }
    if (password.contains(RegExp(r'[a-z]'))) {
      strength++;
    }
    if (password.contains(RegExp(r'\d'))) {
      strength++;
    }
    if (password.contains(RegExp(r'[!@#\$&*~%^()|,.;:?/<>]'))) {
      strength++;
    }

    return strength;
  }
}
