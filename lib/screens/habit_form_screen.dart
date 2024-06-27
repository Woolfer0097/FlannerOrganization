import 'package:flutter/material.dart';
import 'package:flanner/models/habit.dart'; // Import your Habit model

class HabitFormScreen extends StatefulWidget {
  @override
  _HabitFormScreenState createState() => _HabitFormScreenState();
}

class _HabitFormScreenState extends State<HabitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _habitName;
  late String _habitDescription;
  late DateTime _startDate;
  late int _goal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Habit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Habit Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a habit name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _habitName = value!;
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
                  _habitDescription = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Start Date'),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _startDate = pickedDate;
                    });
                  }
                },
                validator: (value) {
                  if (_startDate == null) {
                    return 'Please select a start date';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Goal (Optional)'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _goal = int.tryParse(value!) ?? 0;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Create a new Habit object
                    Habit newHabit = Habit(
                      id: DateTime.now().toString(), // Unique ID for habit
                      name: _habitName,
                      description: _habitDescription,
                      activeDays: [], // Initialize with empty list
                      goal: _goal,
                      // startDate: _startDate,
                    );

                    // Save newHabit to local storage or database
                    // Implement your logic to save the habit

                    // Navigate back to previous screen
                    Navigator.pop(context);
                  }
                },
                child: Text('Save Habit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
