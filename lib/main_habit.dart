import 'package:flutter/material.dart';
import 'package:flanner/screens/main_screen.dart';
import 'package:flanner/screens/calendar_screen.dart';
import 'package:flanner/screens/habit_form_screen.dart';
import 'package:flanner/screens/stats_screen.dart';
import 'package:flanner/screens/goal_setting_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
        '/calendar': (context) => CalendarScreen(),
        '/add_habit': (context) => HabitFormScreen(),
        '/stats': (context) => StatsScreen(),
        '/set_goal': (context) => GoalSettingScreen(),
      },
    );
  }
}
