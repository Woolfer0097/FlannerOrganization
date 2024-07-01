import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'HabbitsScreen.dart';
import 'Theme/Theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      body: Column(
        children: [
          TableCalendar(
            locale: 'en_US',
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