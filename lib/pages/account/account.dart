import 'package:basic_flutter/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:basic_flutter/pages/account/account_update.dart';
import 'package:basic_flutter/pages/account/password_change.dart';

import 'package:basic_flutter/models/user.dart';
import 'package:basic_flutter/config.dart';
import 'package:basic_flutter/widgets/button.dart';
import 'package:basic_flutter/widgets/label_text.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  User? user;
  bool isUserLoading = false;

  void fetchUser() async {
    setState(() {
      isUserLoading = true;
    });

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? token = _prefs.getString('auth-token');

    var response = await http.get(
      Uri.parse('$apiDomain/api/account/'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        user = User.fromMap(json.decode(response.body));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        ),
      );
    }

    setState(() {
      isUserLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const Home(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: isUserLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 25,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ClipOval(
                          child: Material(
                            color: Colors.transparent,
                            child: Ink.image(
                              image:
                                  NetworkImage('$apiDomain${user!.displayPic}'),
                              fit: BoxFit.cover,
                              width: 250,
                              height: 250,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      const LabelText(label: 'Email :'),
                      Text(user!.email),
                      const SizedBox(height: 10),
                      const LabelText(label: 'Username :'),
                      Text(user!.username),
                      const SizedBox(height: 10),
                      const LabelText(label: 'Name :'),
                      user!.name == null
                          ? const SizedBox(height: 10)
                          : Text((user!.name).toString()),
                      const SizedBox(height: 30),
                      Button(
                        label: 'Update Profile',
                        color: Colors.blue.shade400,
                        onClick: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AccountUpdate(
                                user: user,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Button(
                        label: 'Change Password',
                        color: Colors.blue.shade400,
                        onClick: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PasswordChange(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
