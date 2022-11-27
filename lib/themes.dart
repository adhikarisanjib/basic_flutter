import 'package:flutter/material.dart';

CustomTheme currentTheme = CustomTheme();

class CustomTheme with ChangeNotifier {
  static bool _isDarkTheme = false;
  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue.shade300,
      colorScheme: ColorScheme.light(primary: Colors.blue.shade300),
      dividerColor: Colors.black,
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      scaffoldBackgroundColor: Colors.grey.shade900,
      primarySwatch: Colors.blueGrey,
      primaryColorDark: Colors.blueGrey.shade600,
      colorScheme: ColorScheme.dark(primary: Colors.blueGrey.shade300),
      dividerColor: Colors.white,
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
