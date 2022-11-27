import 'package:basic_flutter/themes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:basic_flutter/pages/home.dart';
import 'package:basic_flutter/pages/account/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  String? token;
  bool isLoading = false;

  loadToken() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      token = _pref.getString('auth-token');
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
    loadToken();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: currentTheme.currentTheme,
      home: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : token == null
              ? const Login()
              : const Home(),
    );
  }
}
