import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'AchievementsPage.dart';
import 'Theme/Theme.dart';
import 'ButtonsComponent.dart' as Buttons;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';

class HabitsDisplayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HabitProvider(),
      child: MaterialApp(
        home: HabitTrackerScreen(),
      ),
    );
  }
}

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
    List<String> habitStrings = _habits.map((habit) => json.encode(habit.toMap())).toList();
    await prefs.setStringList('habits', habitStrings);
  }

  // Loading habits from shared preferences
  Future<void> loadHabits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? habitStrings = prefs.getStringList('habits');
    if (habitStrings != null) {
      _habits = habitStrings.map((habitString) => Habit.fromMap(json.decode(habitString))).toList();
    }
    notifyListeners();
  }

  // Saving achievements to shared preferences
  Future<void> saveAchievements() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> achievementStrings = _achievements.map((achievement) => json.encode(achievement.toMap())).toList();
    await prefs.setStringList('achievements', achievementStrings);
  }

  // Loading achievements from shared preferences
  Future<void> loadAchievements() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? achievementStrings = prefs.getStringList('achievements');
    if (achievementStrings != null) {
      _achievements = achievementStrings.map((achievementString) => Achievement.fromMap(json.decode(achievementString))).toList();
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
    return dates.values.where((value) => value == true).length;
  }

  int getSkippedDays() {
    return dates.values.where((value) => value == false).length;
  }

  double getProgress() {
    final totalPlannedDays = endDate.difference(DateTime.now()).inDays + 1;
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
    final totalPlannedDays = endDate.difference(DateTime.now()).inDays + 1;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddHabitScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AchievementsScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<HabitProvider>(
        builder: (context, habitProvider, child) {
          return ListView.builder(
            itemCount: habitProvider.habits.length,
            itemBuilder: (context, index) {
              Habit habit = habitProvider.habits[index];
              return HabitCard(habit: habit);
            },
          );
        },
      ),
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
              '${habit.getCompletedDays()} / ${(habit.endDate.difference(DateTime.now()).inDays + 1)} days completed',
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

class AddHabitScreen extends StatefulWidget {
  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Habit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value ?? '';
                },
              ),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(labelText: 'End Date'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _endDate = pickedDate;
                    });
                  }
                },
                validator: (value) {
                  if (_endDate == null) {
                    return 'Please select an end date';
                  }
                  return null;
                },
                onSaved: (value) {
                  // No need to save as _endDate is already set
                },
                controller: TextEditingController(
                  text: _endDate != null
                      ? _endDate!.toLocal().toString().split(' ')[0]
                      : '',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    Habit newHabit = Habit(
                      title: _title,
                      description: _description,
                      startDate: DateTime.now(),
                      endDate: _endDate!,
                      dates: {},
                    );
                    Provider.of<HabitProvider>(context, listen: false)
                        .addHabit(newHabit);
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Habit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            calendarFormat: CalendarFormat.month,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            headerStyle: HeaderStyle(formatButtonVisible: false),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                bool isCompleted =
                    Provider.of<HabitProvider>(context, listen: false)
                        .habits
                        .any((habit) {
                  return habit.dates.containsKey(DateUtils.dateOnly(day)) &&
                      habit.dates[DateUtils.dateOnly(day)]!;
                });
                bool isHabitDay =
                    Provider.of<HabitProvider>(context, listen: false)
                        .habits
                        .any((habit) {
                  return habit.dates.containsKey(DateUtils.dateOnly(day));
                });
                if (isHabitDay) {
                  if (isCompleted) {
                    return Container(
                      margin: EdgeInsets.all(6.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.green.shade400,
                        shape: BoxShape.circle,
                      ),
                      child: Text(day.day.toString()),
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.all(6.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red.shade400,
                        shape: BoxShape.circle,
                      ),
                      child: Text(day.day.toString()),
                    );
                  }
                }
                return null;
              },
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              Provider.of<HabitProvider>(context, listen: false)
                  .setSelectedDate(selectedDay);
            },
          ),
          Expanded(
            child: Consumer<HabitProvider>(
              builder: (context, habitProvider, child) {
                DateTime selectedDate = habitProvider.selectedDate;
                List<Habit> completedHabits =
                    habitProvider.habits.where((habit) {
                  return habit.dates
                          .containsKey(DateUtils.dateOnly(selectedDate)) &&
                      habit.dates[DateUtils.dateOnly(selectedDate)] == true;
                }).toList();
                List<Habit> plannedHabits = habitProvider.habits.where((habit) {
                  return !habit.dates
                          .containsKey(DateUtils.dateOnly(selectedDate)) &&
                      habit.isPlannedFor(selectedDate);
                }).toList();
                List<Habit> skippedHabits = habitProvider.habits.where((habit) {
                  return habit.dates.entries
                      .where((entry) =>
                          entry.value == false &&
                          entry.key == DateUtils.dateOnly(selectedDate))
                      .isNotEmpty;
                }).toList();

                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Completed Habits',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...completedHabits
                        .map((habit) => ListTile(
                              leading: Icon(Icons.check, color: Colors.green),
                              title: Text(habit.title),
                              subtitle: Text(habit.description),
                            ))
                        .toList(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Planned Habits',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...plannedHabits
                        .map((habit) => ListTile(
                              leading:
                                  Icon(Icons.access_time, color: Colors.orange),
                              title: Text(habit.title),
                              subtitle: Text(habit.description),
                            ))
                        .toList(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Skipped Habits',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...skippedHabits
                        .map((habit) => ListTile(
                              leading: Icon(Icons.cancel, color: Colors.red),
                              title: Text(habit.title),
                              subtitle: Text(habit.description),
                            ))
                        .toList(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
