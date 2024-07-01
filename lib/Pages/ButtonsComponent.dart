import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Theme/Theme.dart';

import 'AddNoteScreen.dart';

class ButtonsComponent {
  final ThemeData themeData;

  ButtonsComponent(this.themeData);

  Widget buildMenuButton(String label) {
    return ElevatedButton(
      style: themeData.elevatedButtonTheme.style,
      onPressed: () {},
      child: Text(label),
    );
  }

  Widget buildNoteButton(String label, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox (
        width: double.infinity,
        child: ElevatedButton(
          style: themeData.elevatedButtonTheme.style,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNoteScreen()),
            );
          },
          child: Text(label),
        ),
      )
    );
  }

  Widget buildTimeButton(String label) {
    return ElevatedButton(
      style: themeData.elevatedButtonTheme.style,
      onPressed: () {},
      child: Text(label),
    );
  }

  Widget buildTaskCard(String label) {
    return Card(
      color: themeData.cardColor,
      child: ListTile(
        title: Text(label),
        trailing: Icon(Icons.more_vert, color: themeData.iconTheme.color),
      ),
    );
  }

  Widget buildCompletedTaskCard(String label) {
    return Card(
      color: themeData.cardColor,
      child: ListTile(
        title: Text(label),
        trailing: Icon(Icons.check, color: Colors.green),
      ),
    );
  }

  Widget buildAddTaskButton(String label) {
    return Card(
      color: themeData.cardColor,
      child: ListTile(
        title: Text(label),
        trailing: Icon(Icons.add, color: Colors.purple),
      ),
    );
  }
}
