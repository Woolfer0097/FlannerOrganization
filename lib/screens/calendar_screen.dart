import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flanner/models/habit.dart'; // Import your Habit model

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Habit>> _events = {}; // Map to store habits for each day

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  // Load habits for the selected day from local storage or database
                  // Replace with your logic to fetch habits for selectedDay
                  // For demo, using a sample list of habits
                  _events[_selectedDay!] = [
                    // Habit(id: '1', name: 'Exercise', description: '30 min jog'),
                    // Habit(id: '2', name: 'Read', description: '1 chapter of a book'),
                  ];
                });
              },
              eventLoader: (day) {
                return _events[day] ?? [];
              },
            ),
            SizedBox(height: 20),
            if (_selectedDay != null && _events.containsKey(_selectedDay))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Habits for ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _events[_selectedDay!]!.length,
                    itemBuilder: (context, index) {
                      Habit habit = _events[_selectedDay!]![index];
                      return ListTile(
                        title: Text(habit.name),
                        subtitle: Text(habit.description),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add habit screen
          Navigator.pushNamed(context, '/add_habit');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
