import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'AchievementsPage.dart';
import 'CalendarScreen.dart';
import 'Theme/Theme.dart';
import 'ButtonsComponent.dart' as Buttons;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';

class HabitProvider extends ChangeNotifier {
  List<Habit> _habits = [];
  List<Achievement> _achievements = [];

  HabitProvider() {
    loadHabits();
    loadAchievements();
  }

  List<Habit> get habits => _habits;

  List<Achievement> get achievements => _achievements;

  // Date selected on the calendar
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void addHabit(Habit habit) {
    _habits.add(habit);
    saveHabits();
    notifyListeners();
  }

  void updateHabit(Habit habit, bool completed) {
    habit.dates[DateUtils.dateOnly(_selectedDate)] = completed;
    if (!completed) {
      habit.dates[DateUtils.dateOnly(_selectedDate)] = true;
    }
    if (habit.getProgress() == 1.0) {
      habit.completeGoal();
      _achievements.add(habit.achievements.last);
      _habits.remove(habit);
      saveAchievements();
      saveHabits();
    } else {
      saveHabits();
    }
    notifyListeners();
  }

  void removeHabit(Habit habit) {
    _habits.remove(habit);
    saveHabits();
    notifyListeners();
  }

  // Saving habits to shared preferences
  Future<void> saveHabits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> habitStrings = _habits.map((habit) =>
        json.encode(habit.toMap())).toList();
    await prefs.setStringList('habits', habitStrings);
  }

  // Loading habits from shared preferences
  Future<void> loadHabits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? habitStrings = prefs.getStringList('habits');
    if (habitStrings != null) {
      _habits = habitStrings.map((habitString) =>
          Habit.fromMap(json.decode(habitString))).toList();
    }
    notifyListeners();
  }

  // Saving achievements to shared preferences
  Future<void> saveAchievements() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> achievementStrings = _achievements.map((achievement) =>
        json.encode(achievement.toMap())).toList();
    await prefs.setStringList('achievements', achievementStrings);
  }

  // Loading achievements from shared preferences
  Future<void> loadAchievements() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? achievementStrings = prefs.getStringList('achievements');
    if (achievementStrings != null) {
      _achievements = achievementStrings.map((achievementString) =>
          Achievement.fromMap(json.decode(achievementString))).toList();
    }
    notifyListeners();
  }
}

class Habit {
  String title;
  String description;
  DateTime startDate;
  DateTime endDate; // Track the end date for the habit goal
  Map<DateTime, bool> dates; // Track completed days
  bool isCompleted; // Flag to check if the habit's goal is completed
  List<Achievement> achievements; // List of achievements earned

  Habit({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.dates,
    this.isCompleted = false,
    this.achievements = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'dates':
      dates.map((key, value) => MapEntry(key.toIso8601String(), value)),
      'is_completed': isCompleted,
      'achievements':
      achievements.map((achievement) => achievement.toMap()).toList(),
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      title: map['title'],
      description: map['description'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      dates: (map['dates'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(DateTime.parse(key), value as bool)),
      isCompleted: map['is_completed'],
      achievements: (map['achievements'] as List<dynamic>)
          .map((achievement) => Achievement.fromMap(achievement))
          .toList(),
    );
  }

  bool isPlannedFor(DateTime day) {
    // if (kDebugMode) {
    //   print(startDate);
    //   print(day);
    //   print(endDate);
    // }
    return (day.isAfter(startDate.subtract(Duration(days: 1))) &&
        day.isBefore(endDate.add(Duration(days: 1))));
  }

  int getCompletedDays() {
    return dates.values
        .where((value) => value == true)
        .length;
  }

  int getSkippedDays() {
    return dates.values
        .where((value) => value == false)
        .length;
  }

  double getProgress() {
    final totalPlannedDays = endDate
        .difference(DateTime.now())
        .inDays + 1;
    if (totalPlannedDays == 0) return 0;
    return getCompletedDays() / totalPlannedDays;
  }

  void completeGoal() {
    isCompleted = true;
    achievements.add(Achievement(
      title: '$title Goal Completed!',
      description: 'Congratulations! You have completed the $title habit goal.',
      dateAchieved: endDate,
    ));
  }

  int getCurrentDays() {
    final totalPlannedDays = endDate
        .difference(DateTime.now())
        .inDays + 1;
    return totalPlannedDays - getSkippedDays();
  }
}

class Achievement {
  String title;
  String description;
  DateTime dateAchieved;

  Achievement({
    required this.title,
    required this.description,
    required this.dateAchieved,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date_achieved': dateAchieved.toIso8601String(),
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      title: map['title'],
      description: map['description'],
      dateAchieved: DateTime.parse(map['date_achieved']),
    );
  }
}

class HabitTrackerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        return ListView.builder(
          itemCount: habitProvider.habits.length,
          itemBuilder: (context, index) {
            Habit habit = habitProvider.habits[index];
            return HabitCard(habit: habit);
          },
        );
      },
    );
  }
}

class HabitCard extends StatelessWidget {
  final Habit habit;

  HabitCard({required this.habit});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(habit.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(habit.description),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: habit.getProgress(),
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 4),
            Text(
              '${habit.getCompletedDays()} / ${(habit.endDate
                  .difference(DateTime.now())
                  .inDays + 1)} days completed',
              style: TextStyle(fontSize: 12),
            ),
            Text(
              '${habit.getSkippedDays()} days skipped',
              style: TextStyle(fontSize: 12, color: Colors.red.shade400),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!habit.isCompleted && habit.isPlannedFor(DateTime.now())) ...[
              TextButton(
                style:
                TextButton.styleFrom(foregroundColor: Colors.red.shade400),
                onPressed: () {
                  Provider.of<HabitProvider>(context, listen: false)
                      .updateHabit(habit, false);
                },
                child: const Text('Skip'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.green.shade400),
                onPressed: () {
                  Provider.of<HabitProvider>(context, listen: false)
                      .updateHabit(habit, true);
                  if (habit.getCompletedDays() == habit.getCurrentDays()) {
                    // if (kDebugMode) {
                    //   print("GOAL COMPLETED");
                    // }
                    habit.completeGoal();
                    Provider.of<HabitProvider>(context, listen: false)
                        .removeHabit(habit);
                    // if (kDebugMode) {
                    //   print(habit.achievements);
                    // }
                  }
                },
                child: Text('Complete'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}