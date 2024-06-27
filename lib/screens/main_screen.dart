import 'package:flutter/material.dart';
import 'package:flanner/models/habit.dart'; // Import your Habit model from flanner

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Habit> _habits = [
  ]; // List to store habits, replace with your actual data source

  @override
  void initState() {
    super.initState();
    // Initialize _habits with sample data, replace with your actual data fetching logic
    _habits =
    [
    // Example habits with different activeDays configurations
    Habit(
    id: '1',
    name: 'Exercise',
    description: '30 min jog every morning',
    activeDays: [DayOfWeek.monday, DayOfWeek.tuesday, DayOfWeek.wednesday, DayOfWeek.thursday, DayOfWeek.friday, DayOfWeek.saturday, DayOfWeek.sunday], // Every day of the week
    ),

    Habit(
    id: '2',
    name: 'Read',
    description: 'Read 1 chapter of a book',
    activeDays: [DayOfWeek.monday, DayOfWeek.wednesday, DayOfWeek.friday], // Monday, Wednesday, Friday
    ),

    Habit(
    id: '3',
    name: 'Meditate',
    description: '10 minutes of meditation',
    activeDays: [DayOfWeek.tuesday, DayOfWeek.thursday, DayOfWeek.saturday], // Sunday, Tuesday, Thursday, Saturday
    ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habits'),
      ),
      body: ListView.builder(
        itemCount: _habits.length,
        itemBuilder: (context, index) {
          Habit habit = _habits[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(habit.name),
              subtitle: Text(habit.description),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle complete action
                      setState(() {
                        // Update habit completion status or remove from list
                        _habits.removeAt(index);
                        // Implement your logic to track completion (e.g., update stats)
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                    child: Text('Complete'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Handle mark as undone action
                      setState(() {
                        // Update habit status (e.g., undo completion)
                        // This could involve resetting some state or moving it back to a pending state
                        // For demo purpose, we are just removing it from the list
                        _habits.removeAt(index);
                        // Implement your logic to handle marking as undone
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    child: Text('Undone'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to habit form screen to add a new habit
          Navigator.pushNamed(context, '/add_habit');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
