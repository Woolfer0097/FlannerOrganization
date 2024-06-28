// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flanner/main_habit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flanner/main.dart';
import 'package:provider/provider.dart';

void main() {
  group('HabitTrackerScreen Tests', () {
    testWidgets('Displays HabitCards and handles adding new habits', (WidgetTester tester) async {
      // Setup the app with HabitProvider
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => HabitProvider(),
          child: MaterialApp(home: HabitTrackerScreen()),
        ),
      );

      // Verify initial state with no habits
      expect(find.byType(HabitCard), findsNothing);

      // Tap the add button to navigate to AddHabitScreen
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle(); // Wait for navigation animation

      // Verify we're on the AddHabitScreen
      expect(find.byType(AddHabitScreen), findsOneWidget);

      // Fill the form and add a habit
      await tester.enterText(find.byType(TextFormField).at(0), 'Exercise');
      await tester.enterText(find.byType(TextFormField).at(1), 'Morning workout');
      await tester.tap(find.byType(TextFormField).at(2)); // Tap to pick date
      await tester.pumpAndSettle();

      // Pick a date for the end goal
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Submit the form
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify we are back on the HabitTrackerScreen
      expect(find.byType(HabitTrackerScreen), findsOneWidget);

      // Check if the new habit is displayed
      expect(find.byType(HabitCard), findsOneWidget);
      expect(find.text('Exercise'), findsOneWidget);
      expect(find.text('Morning workout'), findsOneWidget);
    });
  });

  group('AddHabitScreen Tests', () {
    testWidgets('Displays form and handles user input', (WidgetTester tester) async {
      // Create a simple MaterialApp to host the AddHabitScreen
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => HabitProvider(),
          child: MaterialApp(home: AddHabitScreen()),
        ),
      );

      // Verify the form fields are displayed
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Enter habit details
      await tester.enterText(find.byType(TextFormField).at(0), 'Read Book');
      await tester.enterText(find.byType(TextFormField).at(1), 'Read a chapter daily');

      // Pick a date for the end goal
      await tester.tap(find.byType(TextFormField).at(2)); // Tap to pick date
      await tester.pumpAndSettle();

      await tester.tap(find.text('OK')); // Confirm date
      await tester.pumpAndSettle();

      // Submit the form
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify that the habit was added to the provider (by navigating back or checking provider state)
      // This would ideally be verified by the provider, but here we rely on state changes
    });
  });

  group('HabitCard Tests', () {
    testWidgets('Displays habit information and updates on complete/skip', (WidgetTester tester) async {
      Habit habit = Habit(
        title: 'Drink Water',
        description: 'Drink 8 glasses of water',
        endDate: DateTime.now().add(Duration(days: 7)),
        dates: {},
        skippedDates: {},
      );

      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => HabitProvider()..addHabit(habit),
          child: MaterialApp(
            home: Scaffold(
              body: HabitCard(habit: habit),
            ),
          ),
        ),
      );

      // Verify the habit details are displayed
      expect(find.text('Drink Water'), findsOneWidget);
      expect(find.text('Drink 8 glasses of water'), findsOneWidget);

      // Check initial progress (should be 0)
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      LinearProgressIndicator progressIndicator = tester.widget(find.byType(LinearProgressIndicator));
      expect(progressIndicator.value, 0);

      // Tap the "Complete" button
      await tester.tap(find.text('Complete'));
      await tester.pumpAndSettle();

      // Verify the progress has updated
      progressIndicator = tester.widget(find.byType(LinearProgressIndicator));
      expect(progressIndicator.value, greaterThan(0));

      // Tap the "Skip" button
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      // Check skipped days count
      expect(find.text('1 days skipped'), findsOneWidget);
    });
  });

  group('CalendarScreen Tests', () {
    testWidgets('Displays and highlights completed days', (WidgetTester tester) async {
      DateTime now = DateTime.now();
      Habit habit = Habit(
        title: 'Meditate',
        description: 'Meditate for 10 minutes',
        endDate: now.add(Duration(days: 10)),
        dates: {DateUtils.dateOnly(now): true},
        skippedDates: {},
      );

      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => HabitProvider()..addHabit(habit),
          child: MaterialApp(
            home: CalendarScreen(),
          ),
        ),
      );

      // Verify the calendar is displayed
      expect(find.byType(TableCalendar), findsOneWidget);

      // Check if today's date is highlighted (green)
      Finder todayCell = find.text(now.day.toString());
      expect(todayCell, findsOneWidget);

      // Verify the day is highlighted as completed
      Container container = tester.widget(todayCell.first);
      expect(container.decoration, isNotNull);
      expect((container.decoration as BoxDecoration).color, equals(Colors.greenAccent));
    });
  });
}

