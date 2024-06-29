import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Theme/Theme.dart';

class ButtonsComponent {
  final ThemeData themeData;

  ButtonsComponent(this.themeData);

  Widget buildMenuButton(String label) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: themeData.elevatedButtonTheme.style?.backgroundColor?.resolve({}) ?? themeData.primaryColor,
        textStyle: themeData.elevatedButtonTheme.style?.textStyle?.resolve({}) ?? TextStyle(color: themeData.primaryColor),
      ),
      onPressed: () {},
      child: Text(label),
    );
  }

  Widget buildTabButton(String label) {
    return ElevatedButton(
      style: themeData.elevatedButtonTheme.style,
      onPressed: () {},
      child: Text(label),
    );
  }

  Widget buildTimeButton(String label) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: themeData.primaryColor),
        backgroundColor: themeData.scaffoldBackgroundColor,
        textStyle: TextStyle(color: themeData.primaryColor),
      ),
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
