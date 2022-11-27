import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:basic_flutter/pages/account/password_reset.dart';
import 'package:basic_flutter/config.dart';

import 'package:basic_flutter/widgets/button.dart';
import 'package:basic_flutter/widgets/error_text.dart';
import 'package:basic_flutter/widgets/label_text.dart';

class PasswordResetRequest extends StatefulWidget {
  const PasswordResetRequest({Key? key}) : super(key: key);

  @override
  State<PasswordResetRequest> createState() => _PasswordResetRequestState();
}

class _PasswordResetRequestState extends State<PasswordResetRequest> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email = '';

  String nonFieldError = '';
  String emailError = '';

  String regEmail =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  validation() {
    final FormState? _form = _formKey.currentState;
    if (_form!.validate()) {
      reset();
    }
  }

  reset() async {
    Map data = {
      'email': email,
    };

    var response = await http.post(
      Uri.parse('$apiDomain/api/password_reset_request_token/'),
      body: data,
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Successful'),
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const PasswordReset()),
      );
    } else {
      Map<String, dynamic> errorData = json.decode(response.body);
      setState(() {
        emailError =
            errorData.containsKey('email') ? errorData['email'][0] : '';
        nonFieldError = errorData.containsKey('non_field_errors')
            ? errorData['non_field_errors'][0]
            : '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Reset Request'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LabelText(label: 'Email'),
                const SizedBox(height: 5),
                TextFormField(
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  validator: (value) {
                    if (value == '') {
                      return 'Please enter an email';
                    } else if (!RegExp(regEmail).hasMatch(value!)) {
                      return 'Invalid email address';
                    }
                    return null;
                  },
                ),
                emailError.isEmpty
                    ? const SizedBox()
                    : ErrorText(message: emailError),
                nonFieldError.isEmpty
                    ? const SizedBox()
                    : ErrorText(message: nonFieldError),
                const SizedBox(height: 20),
                Button(
                  label: 'Send Request',
                  onClick: () => {validation()},
                  color: Colors.blue.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
