import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Theme/Theme.dart';
import 'ButtonsComponent.dart' as Buttons;

import 'NotesScreen.dart';
// import 'CalendarScreen.dart';
import 'HabbitsScreen.dart';
import 'SportsScreen.dart';

class BottomNavIndexNotifier extends StateNotifier<int> {
  BottomNavIndexNotifier() : super(2); // Default index is 2 (Home)

  void setIndex(int index) {
    state = index;
  }
}

final bottomNavIndexProvider = StateNotifierProvider<BottomNavIndexNotifier, int>((ref) {
  return BottomNavIndexNotifier();
});

void main() {
  runApp(ProviderScope(child: MainScreen()));
}

class MainScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider);
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final Buttons.ButtonsComponent buttons = Buttons.ButtonsComponent();


    final textStyle = TextStyle(
      color: theme.appBarTheme.titleTextStyle?.color,
    );

    // Define the different screens
    final List<Widget> screens = [
      NotesScreen(),
      CalendarScreen(),
      HomeScreen(buttons: buttons, theme: theme, textStyle: textStyle),
      HabitsDisplayScreen(),
      SportScreen(),
    ];
    final List<AppBar> appBars = [
      AppBar(
        title: Text('Notes', style: textStyle),
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      AppBar(
        title: Text('Calendar', style: textStyle),
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      AppBar(
        title: Text('Flanner', style: textStyle),
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          ElevatedButton(
            onPressed: () => ref.read(themeNotifierProvider.notifier).changeTheme(),
            child: Icon(Icons.dark_mode),
          ),
        ],
      ),
      AppBar(
        title: Text(
          'Habit Tracker',
          style: textStyle,
          textAlign: TextAlign.center,
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddHabitScreen()),
              );
            },
          ),
          ElevatedButton(
            onPressed: () => ref.read(themeNotifierProvider.notifier).changeTheme(),
            child: Icon(Icons.dark_mode),
          ),
        ],
      ),
      AppBar(
        title: Text('Calories Burned Calculator', style: textStyle),
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
    ];


    return MaterialApp(
      home: Scaffold(
        appBar: appBars[currentIndex], // Display the selected AppBar
        body: screens[currentIndex], // Display the selected screen
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.black45,
          currentIndex: currentIndex,
          onTap: (index) => ref.read(bottomNavIndexProvider.notifier).setIndex(index),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.notes), label: "Notes"),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Calendar"),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tasks"),
            BottomNavigationBarItem(icon: Icon(Icons.local_fire_department_rounded), label: "Sport"),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final Buttons.ButtonsComponent buttons;
  final ThemeData theme;
  final TextStyle textStyle;

  HomeScreen({required this.buttons, required this.theme, required this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: theme.primaryColor,
      child: Column(
        children: [
          // Top Tabs
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttons.buildTabButton('Daily', theme.elevatedButtonTheme, textStyle),
                buttons.buildTabButton('Weekly', theme.elevatedButtonTheme, textStyle),
                buttons.buildTabButton('Overall', theme.elevatedButtonTheme, textStyle),
              ],
            ),
          ),
          // Time of Day Buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttons.buildTimeButton('All'),
                buttons.buildTimeButton('Morning'),
                buttons.buildTimeButton('Afternoon'),
                buttons.buildTimeButton('Evening'),
              ],
            ),
          ),
          // Task List
          Expanded(
            child: ListView(
              children: [
                buttons.buildTaskCard('Task 1', Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
