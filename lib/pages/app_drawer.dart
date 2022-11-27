import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:basic_flutter/models/user.dart';
import 'package:basic_flutter/config.dart';

import 'package:basic_flutter/pages/home.dart';
import 'package:basic_flutter/pages/account/account.dart';
import 'package:basic_flutter/pages/account/login.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
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

  void logout() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove('auth-token');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logout Successful'),
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).primaryColor,
      child: ListView(
        children: [
          SizedBox(
            child: isUserLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : UserAccountsDrawerHeader(
                    accountName: Text(user!.username),
                    accountEmail: Text(user!.email),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(
                        '$apiDomain${user!.displayPic}',
                      ),
                    ),
                  ),
          ),
          ListTile(
            title: const Text('Home'),
            trailing: const Icon(Icons.home),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Home(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Profile'),
            trailing: const Icon(Icons.person),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Account(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Logout'),
            trailing: const Icon(Icons.logout),
            onTap: () {
              logout();
            },
          )
        ],
      ),
    );
  }
}
