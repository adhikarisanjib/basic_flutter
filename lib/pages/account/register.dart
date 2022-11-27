import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:basic_flutter/pages/account/login.dart';
import 'package:basic_flutter/config.dart';

import 'package:basic_flutter/widgets/button.dart';
import 'package:basic_flutter/widgets/error_text.dart';
import 'package:basic_flutter/widgets/label_text.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String username = '';
  String email = '';
  String password1 = '';
  String password2 = '';

  String usernameError = '';
  String emailError = '';
  String password1Error = '';
  String password2Error = '';
  String nonFieldError = '';

  String regEmail =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  void validation() {
    final FormState? _form = _formKey.currentState;
    if (_form!.validate()) {
      register();
    }
  }

  void register() async {
    Map data = {
      'email': email,
      'username': username,
      'password1': password1,
      'password2': password2,
      'redirect_link': '',
    };

    var response = await http.post(
      Uri.parse('$apiDomain/api/register/'),
      body: data,
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration Successful'),
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } else {
      Map<String, dynamic> errorData = json.decode(response.body);
      setState(() {
        emailError =
            errorData.containsKey('email') ? errorData['email'][0] : '';
        usernameError =
            errorData.containsKey('username') ? errorData['username'][0] : '';
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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.1,
              horizontal: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 20),
                Form(
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
                      const SizedBox(height: 20),
                      const LabelText(label: 'Username'),
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
                            username = value;
                          });
                        },
                        validator: (value) {
                          if (value == '') {
                            return 'Please enter a username';
                          }
                          return null;
                        },
                      ),
                      usernameError.isEmpty
                          ? const SizedBox()
                          : ErrorText(message: usernameError),
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 20),
                      const LabelText(label: 'Password Confirm'),
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
                            password2 = value;
                          });
                        },
                        validator: (value) {
                          if (value == '') {
                            return 'Please enter a password';
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
                        label: 'Register',
                        onClick: () => {validation()},
                        color: Colors.blue.shade400,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const LabelText(label: 'Already have an account?'),
                    GestureDetector(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
