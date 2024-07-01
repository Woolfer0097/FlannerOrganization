import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:flanner/Pages/AddHabitScreen.dart';
import 'package:flanner/Pages/MainScreen.dart'; // Adjust import based on your project structure

void main() {
  group('Integration Test', () {
    late Widget homeScreen;
    late SharedPreferences mockSharedPreferences;

    setUp(() async {
      // Initialize shared preferences with mock data
      mockSharedPreferences = await SharedPreferences.getInstance();
      await mockSharedPreferences.clear(); // Clear previous data

      // Set up initial habits data in shared preferences
      List<Map<String, dynamic>> initialHabits = [
        {
          'title': 'Exercise',
          'description': 'Exercise for 30 minutes every day',
          'start_date': '2022-01-01T00:00:00.000Z',
          'end_date': '2022-01-31T00:00:00.000Z',
          'dates': {},
          'is_completed': false,
          'achievements': [],
        },
        {
          'title': 'Read',
          'description': 'Read for 10 minutes every day',
          'start_date': '2022-01-01T00:00:00.000Z',
          'end_date': '2022-01-31T00:00:00.000Z',
          'dates': {},
          'is_completed': false,
          'achievements': [],
        },
        {
          'title': 'Meditate',
          'description': 'Meditate for 15 minutes every day',
          'start_date': '2022-01-01T00:00:00.000Z',
          'end_date': '2022-01-31T00:00:00.000Z',
          'dates': {},
          'is_completed': false,
          'achievements': [],
        },
      ];

      await mockSharedPreferences.setStringList(
        'habits',
        initialHabits.map((habit) => jsonEncode(habit)).toList(),
      );

      // Initialize the homeScreen with MaterialApp
      homeScreen = MaterialApp(
        home: MainScreen(),
      );
    });

    testWidgets('Navigate between screens', (WidgetTester tester) async {
      await tester.pumpWidget(homeScreen);

      // Verify if the HomeScreen is displayed initially
      expect(find.byType(HomeScreen), findsOneWidget);

      // Tap on a button that navigates to AddHabitScreen
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Verify if the AddHabitScreen is displayed after navigation
      expect(find.byType(AddHabitScreen), findsOneWidget);

      // Perform an action to navigate back to HomeScreen (assuming back button functionality)
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify if the HomeScreen is displayed again after navigating back
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
