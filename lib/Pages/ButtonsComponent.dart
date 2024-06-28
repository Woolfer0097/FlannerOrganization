import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Theme/Theme.dart';


class ButtonsComponent{

  ButtonsComponent() {}

  Widget buildMenuButton(String label) {
    bool isPressed = false;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isPressed ? Color(0xE2B8FF) : Colors.white,
        textStyle: isPressed ? TextStyle(color: Colors.white) : TextStyle(color: Colors.black),
      ),
      onPressed: () {
        isPressed = !isPressed;
      },
      child: Text(label),
    );
  }

  Widget buildTabButton(String label, ElevatedButtonThemeData color, TextStyle textStyle) {
    return ElevatedButton(
      style: color.style,
      onPressed: () {},
      child: Text(label, style: textStyle),
    );
  }

  Widget buildTimeButton(String label) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.white),
        backgroundColor: Colors.white,
      ),
      onPressed: () {},
      child: Text(label),
    );
  }

  Widget buildTaskCard(String label, Color color) {
    return Card(
      color: color,
      child: ListTile(
        title: Text(label),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }

  Widget buildCompletedTaskCard(String label, Color color) {
    return Card(
      color: color,
      child: ListTile(
        title: Text(label),
        trailing: Icon(Icons.check, color: Colors.green),
      ),
    );
  }

  Widget buildAddTaskButton(String label, Color color) {
    return Card(
      color: color,
      child: ListTile(
        title: Text(label),
        trailing: Icon(Icons.add, color: Colors.purple),
      ),
    );
  }
}