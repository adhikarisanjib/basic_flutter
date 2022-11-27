import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:basic_flutter/pages/account/account.dart';
import 'package:basic_flutter/config.dart';

import 'package:basic_flutter/widgets/button.dart';
import 'package:basic_flutter/widgets/error_text.dart';
import 'package:basic_flutter/widgets/label_text.dart';

class PasswordChange extends StatefulWidget {
  const PasswordChange({Key? key}) : super(key: key);

  @override
  State<PasswordChange> createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String currentPassword = '';
  String password1 = '';
  String password2 = '';

  String currentPasswordError = '';
  String password1Error = '';
  String password2Error = '';
  String nonFieldError = '';

  void validation() {
    final FormState? _form = _formKey.currentState;
    if (_form!.validate()) {
      change();
    }
  }

  void change() async {
    Map data = {
      'current_password': currentPassword,
      'password1': password1,
      'password2': password2,
    };

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? token = _prefs.getString('auth-token');

    var response = await http.post(
      Uri.parse('$apiDomain/api/password_change/'),
      body: data,
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password Changed'),
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Account()),
      );
    } else {
      Map<String, dynamic> errorData = json.decode(response.body);
      setState(() {
        currentPasswordError = errorData.containsKey('current_password')
            ? errorData['current_password'][0]
            : '';
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
        title: const Text('Change PAssword'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LabelText(label: 'Current Password'),
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
                          currentPassword = value;
                        });
                      },
                      validator: (value) {
                        if (value == '') {
                          return 'Please enter current password';
                        }
                        return null;
                      },
                    ),
                    currentPasswordError.isEmpty
                        ? const SizedBox()
                        : ErrorText(message: currentPasswordError),
                    const SizedBox(height: 20),
                    const LabelText(label: 'New Password'),
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
                    const LabelText(label: 'New Password Again'),
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
                          return 'Please enter same password as above';
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
                      label: 'Change',
                      onClick: () => {validation()},
                      color: Colors.blue.shade400,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
