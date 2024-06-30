import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



// Light Theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  canvasColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.purple,
    unselectedItemColor: Colors.grey,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    titleLarge: TextStyle(color: Colors.black),
  ),
  cardColor: Colors.white,
  iconTheme: IconThemeData(color: Colors.black),
);

// Dark Theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  canvasColor: Colors.black,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.purple[200],
    unselectedItemColor: Colors.white,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white),
  ),
  cardColor: Colors.grey[900],
  iconTheme: IconThemeData(color: Colors.white),
);

// Theme Notifier
class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(lightTheme);

  void changeTheme() {
    state = state == darkTheme ? lightTheme : darkTheme;
  }
}

// Theme Notifier Provider
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

// Button State Notifier
class ButtonStateNotifier extends StateNotifier<Color> {
  ButtonStateNotifier() : super(Colors.white);

  void changeColor(Color color) {
    state = color;
  }
}

final buttonStateProvider = StateNotifierProvider<ButtonStateNotifier, Color>((ref) {
  return ButtonStateNotifier();
});
