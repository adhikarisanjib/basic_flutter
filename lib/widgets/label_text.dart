import 'package:flutter/material.dart';

class LabelText extends StatelessWidget {
  final String label;

  const LabelText({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
