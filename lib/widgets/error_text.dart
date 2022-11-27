import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String message;

  const ErrorText({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 5,
          ),
          Text(
            message,
            style: const TextStyle(color: Colors.red, fontSize: 13),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
