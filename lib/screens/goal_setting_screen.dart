import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:flanner/models/goal.dart';


class GoalSettingScreen extends StatefulWidget {
  @override
  _GoalSettingScreenState createState() => _GoalSettingScreenState();
}

class _GoalSettingScreenState extends State<GoalSettingScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _goalName;
  late String _goalDescription;
  late int _targetCount;
  late DateTime _startDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Goal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Goal Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _goalName = value!;
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
                  _goalDescription = value!;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Target Count'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a target count';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _targetCount = int.tryParse(value!) ?? 0;
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _startDate = pickedDate;
                        });
                      }
                    },
                    child: Text('Select Start Date'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Create a new Goal object
                    Goal newGoal = Goal(
                      id: DateTime.now().toString(), // Unique ID for goal
                      name: _goalName,
                      description: _goalDescription,
                      targetCount: _targetCount,
                      startDate: _startDate,
                    );

                    // Save newGoal to local storage or database
                    // Implement your logic to save the goal

                    // Navigate back to previous screen
                    Navigator.pop(context);
                  }
                },
                child: Text('Set Goal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
