import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Theme/Theme.dart';
import 'ButtonsComponent.dart' as Buttons;

class CalorieGainScreen extends StatefulWidget {
  @override
  _CalorieGainScreenState createState() => _CalorieGainScreenState();
}

class _CalorieGainScreenState extends State<CalorieGainScreen> {
  String? selectedFood;
  double caloriesGained = 0.0;

  final List<String> foods = [
    'Apple',
    'Banana',
    'Sandwich',
    'Pizza',
    // Add more foods
  ];

  final Map<String, double> foodCalories = {
    'Apple': 52.0,
    'Banana': 89.0,
    'Sandwich': 200.0,
    'Pizza': 285.0,
    // Add more food and their calorie values
  };

  Future<void> saveCaloriesGained(double calories) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final key = 'calories_gained_$today';
    double totalCalories = (prefs.getDouble(key) ?? 0) + calories;
    await prefs.setDouble(key, totalCalories);
  }

  Future<double> getCaloriesGainedToday() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final key = 'calories_gained_$today';
    return prefs.getDouble(key) ?? 0;
  }

  Future<double> getTotalCaloriesBurnedToday() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final key = 'calories_burned_$today';
    return prefs.getDouble(key) ?? 0;
  }

  Future<double> getTotalCalories() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('totalCalories') ?? 0;
  }

  Future<void> setTotalCalories(double totalCalories) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('totalCalories', totalCalories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedFood,
              hint: Text('Select Food'),
              onChanged: (newValue) {
                setState(() {
                  selectedFood = newValue;
                  caloriesGained = foodCalories[newValue]!;
                });
              },
              items: foods.map((food) {
                return DropdownMenuItem(
                  child: Text(food),
                  value: food,
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await saveCaloriesGained(caloriesGained);
                double totalCaloriesGainedToday = await getCaloriesGainedToday();
                double totalCaloriesBurnedToday = await getTotalCaloriesBurnedToday();
                double currentTotalCalories = await getTotalCalories();

                double newTotalCalories = currentTotalCalories - totalCaloriesBurnedToday + totalCaloriesGainedToday;
                await setTotalCalories(newTotalCalories);

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text(
                      'Calories Gained: ${caloriesGained.toStringAsFixed(2)}\n'
                      'Total Calories Gained Today: ${totalCaloriesGainedToday.toStringAsFixed(2)}\n'
                      'Total Calories Burned Today: ${totalCaloriesBurnedToday.toStringAsFixed(2)}\n'
                      'New Total Calories: ${newTotalCalories.toStringAsFixed(2)}',
                    ),
                  ),
                );
              },
              child: Text('Calculate'),
            ),
          ],
        ),
      ),
    );
  }
}
