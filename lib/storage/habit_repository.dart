import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flanner/models/habit.dart';

class HabitRepository {
  static const String _storageKey = 'habits';

  Future<List<Habit>> getHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = prefs.getStringList(_storageKey) ?? [];
    return habitsJson.map((json) => Habit.fromJson(jsonDecode(json))).toList();
  }

  Future<void> addHabit(Habit habit) async {
    final prefs = await SharedPreferences.getInstance();
    final habits = await getHabits();
    habits.add(habit);
    final habitsJson = habits.map((habit) => jsonEncode(habit.toJson())).toList();
    prefs.setStringList(_storageKey, habitsJson);
  }

  Future<void> updateHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = habits.map((habit) => jsonEncode(habit.toJson())).toList();
    prefs.setStringList(_storageKey, habitsJson);
  }
}
