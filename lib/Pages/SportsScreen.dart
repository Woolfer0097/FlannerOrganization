import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Theme/Theme.dart';
import 'ButtonsComponent.dart' as Buttons;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: WorkoutScreen(),
    );
  }
}

class WorkoutScreen extends StatefulWidget {
  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  String? selectedWorkout;
  String? selectedIntensity;
  double weight = 70.0; // default value
  double height = 170.0; // default value
  String? gender; // initially null to avoid issues before localizations load
  double timeSpent = 0.0;

  late List<String> workouts;
  late List<String> intensities;
  AppLocalizations? localizations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = AppLocalizations.of(context);

    workouts = [
      localizations!.running,
      localizations!.cycling,
      localizations!.swimming,
      localizations!.walking,
      // Add more workouts
    ];

    intensities = [
      localizations!.low,
      localizations!.medium,
      localizations!.high,
    ];

    // Set default gender value after localizations are loaded
    gender = localizations!.male;
  }

  double calculateCalories() {
    double met = 0.0;
    switch (selectedWorkout) {
      case 'Running':
        met = selectedIntensity == 'High' ? 11.0 : selectedIntensity == 'Medium' ? 8.0 : 6.0;
        break;
      case 'Cycling':
        met = selectedIntensity == 'High' ? 10.0 : selectedIntensity == 'Medium' ? 8.0 : 4.0;
        break;
      case 'Swimming':
        met = selectedIntensity == 'High' ? 9.8 : selectedIntensity == 'Medium' ? 6.8 : 5.0;
        break;
      case 'Walking':
        met = selectedIntensity == 'High' ? 3.8 : selectedIntensity == 'Medium' ? 3.0 : 2.5;
        break;
      default:
        met = 1.0;
    }

    return met * weight * (timeSpent / 60);
  }

  Future<void> saveCaloriesBurned(double calories) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final key = 'calories_burned_$today';
    double totalCalories = (prefs.getDouble(key) ?? 0) + calories;
    await prefs.setDouble(key, totalCalories);
  }

  Future<double> getCaloriesBurnedToday() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final key = 'calories_burned_$today';
    return prefs.getDouble(key) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    if (localizations == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: workouts.contains(selectedWorkout) ? selectedWorkout : null,
              hint: Text(AppLocalizations.of(context)!.select_workout),
              onChanged: (newValue) {
                setState(() {
                  selectedWorkout = newValue;
                });
              },
              items: workouts.map((workout) {
                return DropdownMenuItem(
                  child: Text(workout),
                  value: workout,
                );
              }).toList(),
            ),
            DropdownButton<String>(
              value: intensities.contains(selectedIntensity) ? selectedIntensity : null,
              hint: Text(AppLocalizations.of(context)!.select_intensity),
              onChanged: (newValue) {
                setState(() {
                  selectedIntensity = newValue;
                });
              },
              items: intensities.map((intensity) {
                return DropdownMenuItem(
                  child: Text(intensity),
                  value: intensity,
                );
              }).toList(),
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.weight),
              onChanged: (value) {
                setState(() {
                  weight = double.parse(value);
                });
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.height),
              onChanged: (value) {
                setState(() {
                  if (double.tryParse(value) != null) {
                    height = double.parse(value);
                  }
                });
              },
            ),
            DropdownButton<String>(
              value: gender,
              hint: Text(AppLocalizations.of(context)!.select_gender),
              onChanged: (newValue) {
                setState(() {
                  gender = newValue!;
                });
              },
              items: [localizations!.male, localizations!.female].map((gender) {
                return DropdownMenuItem(
                  child: Text(gender),
                  value: gender,
                );
              }).toList(),
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.time_spent),
              onChanged: (value) {
                setState(() {
                  timeSpent = double.parse(value);
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                double caloriesBurned = calculateCalories();
                await saveCaloriesBurned(caloriesBurned);
                double totalCaloriesBurnedToday = await getCaloriesBurnedToday();

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text(
                      localizations!.calories_burned + ": " + caloriesBurned.toStringAsFixed(2) + ' kcal \n' + 
                      localizations!.total_calories_burned + ": " + totalCaloriesBurnedToday.toStringAsFixed(2) + ' kcal',
                    ),
                  ),
                );
              },
              child: Text(AppLocalizations.of(context)!.calculate),
            ),
          ],
        ),
      ),
    );
  }
}
