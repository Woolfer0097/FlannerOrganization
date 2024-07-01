import 'package:flanner/Pages/AchievementsPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    hide ChangeNotifierProvider, Consumer;
import 'Theme/Theme.dart';
import 'ButtonsComponent.dart' as Buttons;

import 'AddHabitScreen.dart';
import 'NotesScreen.dart';
import 'CalendarScreen.dart';
import 'HabbitsScreen.dart';
import 'SportsScreen.dart';
import 'AddNoteScreen.dart';

class BottomNavIndexNotifier extends StateNotifier<int> {
  BottomNavIndexNotifier() : super(2); // Default index is 2 (Home)

  void setIndex(int index) {
    state = index;
  }
}

final bottomNavIndexProvider = StateNotifierProvider<BottomNavIndexNotifier,
    int>((ref) {
  return BottomNavIndexNotifier();
});

class MainScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider);
    final buttonTheme = ref.watch(buttonStateProvider);
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final Buttons.ButtonsComponent buttons = Buttons.ButtonsComponent(theme);

    final textStyle = TextStyle(
      color: theme.appBarTheme.titleTextStyle?.color,
    );


    final List<Widget> screens = [
      NotesScreen(),
      CalendarScreen(),
      HomeScreen(theme: theme, textStyle: textStyle),
      HabitTrackerScreen(buttons: buttons, theme: theme, textStyle: textStyle),
      SportScreen(),
    ];
    final List<AppBar> appBars = [
      AppBar(
        title: Text('Notes', style: textStyle),
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          ElevatedButton(
            onPressed: () =>
                ref.read(themeNotifierProvider.notifier).changeTheme(),
            child: Icon(Icons.dark_mode),
          ),
        ],
      ),
      AppBar(
        title: Text('Calendar', style: textStyle),
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          ElevatedButton(
            onPressed: () =>
                ref.read(themeNotifierProvider.notifier).changeTheme(),
            child: Icon(Icons.dark_mode),
          ),
        ],
      ),
      AppBar(
        title: Text('Flanner', style: textStyle),
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          ElevatedButton(
            onPressed: () =>
                ref.read(themeNotifierProvider.notifier).changeTheme(),
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
          Builder( // Ensure the correct context for navigation
            builder: (context) =>
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CalendarScreen()),
                    );
                  },
                ),
          ),
          Builder( // Ensure the correct context for navigation
            builder: (context) =>
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddHabitScreen()),
                    );
                  },
                ),
          ),
          Builder( // Ensure the correct context for navigation
            builder: (context) =>
                IconButton(
                  icon: Icon(Icons.star),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AchievementsScreen()),
                    );
                  },
                ),
          ),
          ElevatedButton(
            onPressed: () =>
                ref.read(themeNotifierProvider.notifier).changeTheme(),
            child: Icon(Icons.dark_mode),
          ),
        ],
      ),
      AppBar(
        title: Text('Calories Burned Calculator', style: textStyle),
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          ElevatedButton(
            onPressed: () =>
                ref.read(themeNotifierProvider.notifier).changeTheme(),
            child: Icon(Icons.dark_mode),
          ),
        ],
      ),
    ];

    return ChangeNotifierProvider(
      create: (context) => HabitProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          appBar: appBars[currentIndex], // Display the selected AppBar
          body: screens[currentIndex], // Display the selected screen
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
            selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
            unselectedItemColor: theme.bottomNavigationBarTheme
                .unselectedItemColor,
            currentIndex: currentIndex,
            onTap: (index) =>
                ref.read(bottomNavIndexProvider.notifier).setIndex(index),
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.notes), label: "Notes"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month), label: "Calendar"),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tasks"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.local_fire_department_rounded),
                  label: "Sport"),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  final ThemeData theme;
  final TextStyle textStyle;

  HomeScreen({
    required this.theme,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitProviderProvider).habits;
    final notes = ref.watch(notesProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: habits.isEmpty && notes.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'There are no habits or notes yet',
                      style: textStyle.copyWith(color: Colors.grey),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddHabitScreen()),
                        );
                      },
                      child: Text('Add Habit'),
                    ),
                    Spacer(),
                    buttons.buildNoteButton('Add note', context),
                  ],
                ),
              )
                  : ListView(
                children: [
                  if (habits.isNotEmpty) ...[
                    Text('Habits', style: textStyle),
                    SizedBox(height: 10),
                    ...habits.map((habit) {
                      return HabitCard(habit: habit);
                    }).toList(),
                  ],
                  if (notes.isNotEmpty) ...[
                    SizedBox(height: 20),
                    Text('Notes', style: textStyle),
                    SizedBox(height: 10),
                    ...notes.map((note) {
                      return NoteCard(
                        note: note,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddNoteScreen(
                                noteIndex: notes.indexOf(note),
                              ),
                            ),
                          );
                        },
                        onDelete: () {
                          ref.read(notesProvider.notifier).remove(notes.indexOf(note));
                        },
                      );
                    }).toList(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

