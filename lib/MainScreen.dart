import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'Pages/Theme/Theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MainScreen()));
}


class MainScreen extends ConsumerWidget{
  @override
  Widget build(BuildContext context,  WidgetRef ref) {

    final theme = ref.watch(themeNotifierProvider);

    final textStyle = TextStyle(
      color: theme.appBarTheme.titleTextStyle?.color,
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          
          title: Text(
            'Home',
            style: textStyle,
          ),
          backgroundColor: theme.scaffoldBackgroundColor,
          actions: [
            ElevatedButton(onPressed: () => ref.read(themeNotifierProvider.notifier).changeTheme() , child: Icon(Icons.dark_mode)),
            // Icon(Icons.more_vert),
          ],
        ),
        body: Container(
          color: theme.primaryColor,
          child: Column(
            children: [
              // Top Tabs
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMenuButton('Daily'),
                    _buildTabButton('Weekly', theme.elevatedButtonTheme, textStyle),
                    _buildTabButton('Overall', theme.elevatedButtonTheme, textStyle),
                  ],
                ),
              ),
              // Time of Day Buttons
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTimeButton('All'),
                    _buildTimeButton('Morning'),
                    _buildTimeButton('Afternoon'),
                    _buildTimeButton('Evening'),
                  ],
                ),
              ),
              // Task List
              Expanded(
                child: ListView(
                  children: [
                    _buildTaskCard('Set Small Goals', Colors.pink),
                    _buildTaskCard('Work', Colors.lightBlue),
                    _buildTaskCard('Meditation', Colors.lightGreen),
                    _buildTaskCard('Basketball', Colors.orange),
                    Divider(color: Colors.white),
                    _buildCompletedTaskCard('Sleep Over 8h', Colors.lightBlue),
                    _buildCompletedTaskCard('Playing Games', Colors.pink),
                    _buildAddTaskButton('Exercise or Workout', Colors.lightGreen),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.mood), label: 'Mood Stat'),
            BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Report'),
            BottomNavigationBarItem(icon: Icon(Icons.wb_incandescent_sharp), label: 'My Habits'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(String label) {
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

  Widget _buildTabButton(String label, ElevatedButtonThemeData color, TextStyle textStyle) {
    return ElevatedButton(
      
      style: color.style,
      onPressed: () {},
      child: Text(label, style: textStyle),
    );
  }

  Widget _buildTimeButton(String label) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.white),
        backgroundColor: Colors.white,
      ),
      onPressed: () {},
      child: Text(label),
    );
  }

  Widget _buildTaskCard(String label, Color color) {
    return Card(
      color: color,
      child: ListTile(
        title: Text(label),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }

  Widget _buildCompletedTaskCard(String label, Color color) {
    return Card(
      color: color,
      child: ListTile(
        title: Text(label),
        trailing: Icon(Icons.check, color: Colors.green),
      ),
    );
  }

  Widget _buildAddTaskButton(String label, Color color) {
    return Card(
      color: color,
      child: ListTile(
        title: Text(label),
        trailing: Icon(Icons.add, color: Colors.purple),
      ),
    );
  }
}