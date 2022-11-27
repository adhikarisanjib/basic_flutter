import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:basic_flutter/pages/account/login.dart';
import 'package:basic_flutter/config.dart';

import 'package:basic_flutter/widgets/button.dart';
import 'package:basic_flutter/widgets/error_text.dart';
import 'package:basic_flutter/widgets/label_text.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({Key? key}) : super(key: key);

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String token = '';
  String email = '';
  String password1 = '';
  String password2 = '';

  String nonFieldError = '';
  String tokenError = '';
  String emailError = '';
  String password1Error = '';
  String password2Error = '';

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
      'token': token,
      'email': email,
      'password1': password1,
      'password2': password2,
    };

    var response = await http.post(
      Uri.parse('$apiDomain/api/password_reset_token/'),
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
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } else {
      Map<String, dynamic> errorData = json.decode(response.body);
      setState(() {
        tokenError =
            errorData.containsKey('token') ? errorData['token'][0] : '';
        emailError =
            errorData.containsKey('email') ? errorData['email'][0] : '';
        password1Error =
            errorData.containsKey('password1') ? errorData['password1'][0] : '';
        password2Error =
            errorData.containsKey('password2') ? errorData['password2'][0] : '';
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
        title: const Text('Password Reset'),
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
                const LabelText(label: 'Token'),
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
                      token = value;
                    });
                  },
                  validator: (value) {
                    if (value == '') {
                      return 'Please enter a token';
                    }
                    return null;
                  },
                ),
                tokenError.isEmpty
                    ? const SizedBox()
                    : ErrorText(message: tokenError),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                const LabelText(label: 'Password'),
                const SizedBox(height: 5),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      password1 = value;
                    });
                  },
                  validator: (value) {
                    if (value == '') {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                password1Error.isEmpty
                    ? const SizedBox()
                    : ErrorText(message: password1Error),
                const SizedBox(height: 10),
                const LabelText(label: 'Confirm Password'),
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
                      password2 = value;
                    });
                  },
                  validator: (value) {
                    if (value == '') {
                      return 'Please enter a token';
                    }
                    return null;
                  },
                ),
                password2Error.isEmpty
                    ? const SizedBox()
                    : ErrorText(message: password2Error),
                nonFieldError.isEmpty
                    ? const SizedBox()
                    : ErrorText(message: nonFieldError),
                const SizedBox(height: 20),
                Button(
                  label: 'Reset',
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
