import 'package:flutter/material.dart';
import 'package:mpi_new/presentations/presentations.dart';

class FormError extends StatelessWidget {
  const FormError({
    Key? key,
    required this.errors,
  }) : super(key: key);

  final List<String?> errors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Column(
        children: List.generate(
            errors.length, (index) => formErrorText(error: errors[index]!)),
      ),
    );
  }

  Widget formErrorText({required String error}) {
    return Row(
      children: [
        Image.asset(
          MyAssets.formError,
          height: 20,
          width: 20,
          color: Colors.red,
        ),
        const SizedBox(
          width: 14,
        ),
        Flexible(
          child: Text(
            error,
            style: MyStyle.styleTextError,
          ),
        ),
      ],
    );
  }
}
