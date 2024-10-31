import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mpi_new/presentations/common/colors.dart';

class LabelForm extends StatefulWidget {
  const LabelForm({
    Key? key,
    required this.isRequired,
    this.isPaddingLeft,
    required this.label,
  }) : super(key: key);

  final bool isRequired;
  final bool? isPaddingLeft;
  final String label;

  @override
  State<LabelForm> createState() => _LabelFormState();
}

class _LabelFormState extends State<LabelForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            EdgeInsets.fromLTRB(widget.isPaddingLeft ?? true ? 8 : 0, 10, 0, 4),
        child: widget.isRequired == true
            ? RichText(
                text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: widget.label.tr(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MyColor.textDarkBlue)),
                const TextSpan(
                    text: ' * ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: MyColor.textRed)),
              ]))
            : RichText(
                text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: widget.label.tr(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MyColor.textDarkBlue)),
              ])));
  }
}
