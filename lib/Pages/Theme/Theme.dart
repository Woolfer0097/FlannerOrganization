import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Light Theme
final ThemeData lightTheme = ThemeData(
  dialogBackgroundColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(
      inherit: true,
      color: Colors.black,
    ),
    backgroundColor: Colors.white,
    elevation: 0,
  ),
  primaryColor: Colors.white,
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xE2B8FF),
    disabledColor: Colors.white,
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return Color(0xE2B8FF); // Color when tapped
        }
        return Colors.white; // Default color
      }),
      textStyle: MaterialStateProperty.resolveWith<TextStyle>((Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return TextStyle(
            inherit: true,
            color: Colors.white,
          ); // Color when tapped
        }
        return TextStyle(
          inherit: true,
          color: Colors.black,
        ); // Default color
      }),
    ),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xE2B8FF),
  ),
);

// Dark Theme
final ThemeData darkTheme = ThemeData(
  dialogBackgroundColor: Colors.black,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(
      inherit: true,
      color: Colors.white,
    ),
    backgroundColor: Colors.black,
    elevation: 0,
  ),
  primaryColor: Colors.black,
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xE2B8FF),
    disabledColor: Colors.black,
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return Color(0xE2B8FF); // Color when tapped
        }
        return Colors.black; // Default color
      }),
      textStyle: MaterialStateProperty.resolveWith<TextStyle>((Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return TextStyle(
            inherit: true,
            color: Colors.black,
          ); // Color when tapped
        }
        return TextStyle(
          inherit: true,
          color: Colors.white,
        ); // Default color
      }),
    ),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xE2B8FF),
  ),
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
