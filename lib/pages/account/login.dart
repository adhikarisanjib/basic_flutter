import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:basic_flutter/pages/home.dart';
import 'package:basic_flutter/pages/account/register.dart';
import 'package:basic_flutter/pages/account/password_reset_request.dart';

import 'package:basic_flutter/config.dart';
import 'package:basic_flutter/widgets/button.dart';
import 'package:basic_flutter/widgets/error_text.dart';
import 'package:basic_flutter/widgets/label_text.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  String emailError = '';
  String passwordError = '';
  String nonFieldError = '';

  String regEmail =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  validation() {
    final FormState? _form = _formKey.currentState;
    if (_form!.validate()) {
      login();
    }
  }

  login() async {
    Map data = {
      'username': email,
      'password': password,
    };

    var response = await http.post(
      Uri.parse('$apiDomain/api/login/'),
      body: data,
    );

    if (response.statusCode == 200) {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String token = jsonDecode(response.body)['token'];
      _prefs.setString('auth-token', token);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Successful'),
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } else {
      Map<String, dynamic> errorData = json.decode(response.body);
      setState(() {
        emailError =
            errorData.containsKey('username') ? errorData['username'][0] : '';
        passwordError =
            errorData.containsKey('password') ? errorData['password'][0] : '';
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
                  'Login',
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
                            password = value;
                          });
                        },
                        validator: (value) {
                          if (value == '') {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                      ),
                      passwordError.isEmpty
                          ? const SizedBox()
                          : ErrorText(message: passwordError),
                      nonFieldError.isEmpty
                          ? const SizedBox()
                          : ErrorText(message: nonFieldError),
                      const SizedBox(height: 20),
                      Button(
                        label: 'Login',
                        onClick: () => {validation()},
                        color: Colors.blue.shade400,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: GestureDetector(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const PasswordResetRequest(),
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const LabelText(label: 'Need an account?'),
                    GestureDetector(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const Register(),
                            ),
                          );
                        },
                        child: const Text(
                          'Register',
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
