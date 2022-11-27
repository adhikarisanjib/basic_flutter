import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final Function onClick;
  final Color color;

  const Button(
      {Key? key,
      required this.label,
      required this.onClick,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: TextButton(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: Colors.blue.shade300,
        ),
        onPressed: () => {onClick()},
      ),
    );
  }
}
