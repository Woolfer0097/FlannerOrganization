import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HabitProvider(),
      child: MaterialApp(
        title: 'Habit Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HabitTrackerScreen(),
      ),
    );
  }
}

class HabitProvider extends ChangeNotifier {
  List<Habit> _habits = [];
  DateTime _selectedDate = DateTime.now();

  HabitProvider() {
    loadHabits();
  }

  List<Habit> get habits => _habits;

  DateTime get selectedDate => _selectedDate;

  void addHabit(Habit habit) {
    _habits.add(habit);
    saveHabits();
    notifyListeners();
  }

  void removeHabit(Habit habit) {
    _habits.remove(habit);
    saveHabits();
    notifyListeners();
  }

  void updateHabit(Habit habit, bool isCompleted) {
    habit.dates[DateUtils.dateOnly(_selectedDate)] = isCompleted;
    saveHabits();
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void saveHabits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> habitsString = _habits.map((habit) => jsonEncode(habit.toMap())).toList();
    prefs.setStringList('habits', habitsString);
  }

  void loadHabits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> habitsString = prefs.getStringList('habits') ?? [];
    _habits = habitsString.map((string) => Habit.fromMap(jsonDecode(string))).toList();
    notifyListeners();
  }
}

// Define a Habit class
class Habit {
  String title;
  String description;
  DateTime endDate; // Track the end date for the habit goal
  Map<DateTime, bool> dates; // Track completed days
  Map<DateTime, bool> skippedDates; // Track skipped days

  Habit({
    required this.title,
    required this.description,
    required this.endDate,
    required this.dates,
    required this.skippedDates,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'end_date': endDate.toIso8601String(),
      'dates': dates.map((key, value) => MapEntry(key.toIso8601String(), value)),
      'skipped_dates': skippedDates.map((key, value) => MapEntry(key.toIso8601String(), value)),
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      title: map['title'],
      description: map['description'],
      endDate: DateTime.parse(map['end_date']),
      dates: (map['dates'] as Map<String, dynamic>).map((key, value) => MapEntry(DateTime.parse(key), value as bool)),
      skippedDates: (map['skipped_dates'] as Map<String, dynamic>).map((key, value) => MapEntry(DateTime.parse(key), value as bool)),
    );
  }

  bool isPlannedFor(DateTime day) {
    return day.isBefore(endDate) || isSameDay(day, endDate);
  }

  int getCompletedDays() {
    return dates.values.where((isCompleted) => isCompleted).length;
  }

  int getSkippedDays() {
    return skippedDates.length;
  }

  double getProgress() {
    final totalPlannedDays = endDate.difference(DateTime.now()).inDays + 1;
    if (totalPlannedDays == 0) return 0;
    return getCompletedDays() / totalPlannedDays;
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
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red.shade400),
              onPressed: () {
                DateTime today = DateTime.now();
                if (habit.isPlannedFor(today)) {
                  Provider.of<HabitProvider>(context, listen: false).updateHabit(habit, false);
                }
              },
              child: Text('Skip'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.green.shade400),
              onPressed: () {
                DateTime today = DateTime.now();
                if (habit.isPlannedFor(today)) {
                  Provider.of<HabitProvider>(context, listen: false).updateHabit(habit, true);
                }
              },
              child: Text('Complete'),
            ),
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
                  text: _endDate != null ? _endDate!.toLocal().toString().split(' ')[0] : '',
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
                      endDate: _endDate!,
                      dates: {},
                      skippedDates: {},
                    );
                    Provider.of<HabitProvider>(context, listen: false).addHabit(newHabit);
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
                bool isCompleted = Provider.of<HabitProvider>(context, listen: false).habits.any((habit) {
                  return habit.dates.containsKey(DateUtils.dateOnly(day)) && habit.dates[DateUtils.dateOnly(day)]!;
                });
                bool isHabitDay = Provider.of<HabitProvider>(context, listen: false).habits.any((habit) {
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
              Provider.of<HabitProvider>(context, listen: false).setSelectedDate(selectedDay);
            },
          ),
          Expanded(
            child: Consumer<HabitProvider>(
              builder: (context, habitProvider, child) {
                DateTime selectedDate = habitProvider.selectedDate;
                List<Habit> completedHabits = habitProvider.habits.where((habit) {
                  return habit.dates.containsKey(DateUtils.dateOnly(selectedDate)) &&
                      habit.dates[DateUtils.dateOnly(selectedDate)] == true;
                }).toList();
                List<Habit> plannedHabits = habitProvider.habits.where((habit) {
                  return !habit.dates.containsKey(DateUtils.dateOnly(selectedDate)) &&
                      habit.isPlannedFor(selectedDate);
                }).toList();
                List<Habit> skippedHabits = habitProvider.habits.where((habit) {
                  return habit.skippedDates.containsKey(DateUtils.dateOnly(selectedDate));
                }).toList();

                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Completed Habits',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...completedHabits.map((habit) => ListTile(
                      leading: Icon(Icons.check, color: Colors.green),
                      title: Text(habit.title),
                      subtitle: Text(habit.description),
                    )).toList(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Planned Habits',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...plannedHabits.map((habit) => ListTile(
                      leading: Icon(Icons.access_time, color: Colors.orange),
                      title: Text(habit.title),
                      subtitle: Text(habit.description),
                    )).toList(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Skipped Habits',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...skippedHabits.map((habit) => ListTile(
                      leading: Icon(Icons.cancel, color: Colors.red),
                      title: Text(habit.title),
                      subtitle: Text(habit.description),
                    )).toList(),
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
