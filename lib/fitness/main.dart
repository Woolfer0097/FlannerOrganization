import 'package:flutter/material.dart';
<<<<<<< Updated upstream:lib/fitness/main.dart

void main() => runApp(FitnessApp());

class FitnessApp extends StatelessWidget {
=======
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Theme/Theme.dart';
import 'ButtonsComponent.dart' as Buttons;

class SportScreen extends StatelessWidget {
>>>>>>> Stashed changes:lib/Pages/SportsScreen.dart
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WorkoutScreen(),
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
  String gender = 'Male'; // default value
  int reps = 0;
  double timeSpent = 0.0;

  final List<String> workouts = [
    'Running',
    'Cycling',
    'Swimming',
    'Walking',
    // Add more workouts
  ];

  final List<String> intensities = [
    'Low',
    'Medium',
    'High',
  ];

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
      // Add more cases for different workouts
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
    return Scaffold(
      appBar: AppBar(title: Text('Calories Burned Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedWorkout,
              hint: Text('Select Workout'),
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
              value: selectedIntensity,
              hint: Text('Select Intensity'),
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
              decoration: InputDecoration(labelText: 'Weight (kg)'),
              onChanged: (value) {
                setState(() {
                  weight = double.parse(value);
                });
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Height (cm)'),
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
              hint: Text('Select Gender'),
              onChanged: (newValue) {
                setState(() {
                  gender = newValue!;
                });
              },
              items: ['Male', 'Female'].map((gender) {
                return DropdownMenuItem(
                  child: Text(gender),
                  value: gender,
                );
              }).toList(),
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Time Spent (minutes)'),
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
                      'Calories Burned: ${caloriesBurned.toStringAsFixed(2)}\n'
                      'Total Calories Burned Today: ${totalCaloriesBurnedToday.toStringAsFixed(2)}',
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
