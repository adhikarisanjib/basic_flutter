import 'package:basic_flutter/pages/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:basic_flutter/pages/account/account_search.dart';
import 'package:basic_flutter/pages/app_drawer.dart';
import 'package:basic_flutter/themes.dart';

import 'package:basic_flutter/models/user.dart';
import 'package:basic_flutter/config.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Icon _searchIcon = const Icon(Icons.search);
  Widget _appBarTitle = const Text(
    'Home',
    style: TextStyle(fontWeight: FontWeight.bold),
  );

  List<User>? _users;
  User? user;
  bool isUserLoading = false;

  loadQuerySearch(value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString('auth-token');

    var response = await http.post(
      Uri.parse('$apiDomain/api/account_search/'),
      headers: {'Authorization': 'Token $token'},
      body: {'userQuery': value},
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      try {
        List<User> users = [];
        for (var data in jsonData) {
          users.add(User.fromMap(data));
        }
        setState(() {
          _users = users;
        });

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AccountSearch(users: _users!, found: true),
          ),
        );
      } catch (e) {
        setState(() {
          _users = [];
        });

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AccountSearch(users: [], found: false),
          ),
        );
      }
    } else {
      // print(response.body);
    }
  }

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
    fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        actions: [
          IconButton(
            icon: _searchIcon,
            onPressed: () {
              setState(() {
                if (_searchIcon.icon == Icons.search) {
                  _searchIcon = const Icon(Icons.close);
                  _appBarTitle = TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search...',
                    ),
                    onSubmitted: (value) {
                      loadQuerySearch(value);
                    },
                  );
                } else {
                  _searchIcon = const Icon(Icons.search);
                  _appBarTitle = const Text(
                    'Home',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  );
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.brightness_4_rounded),
            onPressed: () {
              currentTheme.toggleTheme();
            },
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: const SafeArea(
        child: Center(
          child: Text('Homepage'),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(),
    );
  }
}
