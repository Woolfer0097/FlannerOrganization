import 'package:flutter/material.dart';

class HabitCard extends StatelessWidget {
  final String habitName;
  final String habitDescription;
  final Function() onComplete;
  final Function() onSkip;

  HabitCard({
    required this.habitName,
    required this.habitDescription,
    required this.onComplete,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(habitName),
        subtitle: Text(habitDescription),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: onComplete,
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: onSkip,
            ),
          ],
        ),
      ),
    );
  }
}
