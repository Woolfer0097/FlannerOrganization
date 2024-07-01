import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    hide ChangeNotifierProvider, Consumer;
import 'package:provider/provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'Theme/Theme.dart';
import 'ButtonsComponent.dart' as Buttons;

import 'AddHabitScreen.dart';
import 'AchievementsPage.dart';

import 'NotesScreen.dart';
import 'CalendarScreen.dart';
import 'HabbitsScreen.dart';
import 'SportsScreen.dart';
import 'AddNoteScreen.dart';
import 'CalorieGainScreen.dart';

class BottomNavIndexNotifier extends StateNotifier<int> {
  BottomNavIndexNotifier() : super(2); // Default index is 2 (Home)

  void setIndex(int index) {
    state = index;
  }
}

final bottomNavIndexProvider = StateNotifierProvider<BottomNavIndexNotifier, int>((ref) {
  return BottomNavIndexNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(Locale('en'));

  void setLocale(Locale locale) {
    state = locale;
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class MainScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider);
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final locale = ref.watch(localeProvider);
    final Buttons.ButtonsComponent buttons = Buttons.ButtonsComponent(theme);

    final textStyle = TextStyle(
      color: theme.appBarTheme.titleTextStyle?.color,
    );

    final List<Widget> screens = [
      NotesScreen(),
      CalendarScreen(),
      HomeScreen(theme: theme, textStyle: textStyle),
      HabitTrackerScreen(),
      SportScreen(),
      CalorieGainScreen(),
    ];
    final List<AppBar> appBars = [
      AppBar(
        title: Text(AppLocalizations.of(context)!.notes, style: textStyle),
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          ElevatedButton(
            onPressed: () => ref.read(themeNotifierProvider.notifier).changeTheme(),
            child: Icon(Icons.dark_mode),
          ),
          _buildLanguageSwitcher(ref, context),
        ],
      ),
      AppBar(
        title: Text(AppLocalizations.of(context)!.calendar, style: textStyle),
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          ElevatedButton(
            onPressed: () => ref.read(themeNotifierProvider.notifier).changeTheme(),
            child: Icon(Icons.dark_mode),
          ),
          _buildLanguageSwitcher(ref, context),
        ],
      ),
      AppBar(
        title: Text(AppLocalizations.of(context)!.name, style: textStyle),
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          ElevatedButton(
            onPressed: () => ref.read(themeNotifierProvider.notifier).changeTheme(),
            child: Icon(Icons.dark_mode),
          ),
          _buildLanguageSwitcher(ref, context),
        ],
      ),
      AppBar(
        title: Text(
          AppLocalizations.of(context)!.habit_tracker,
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
                      MaterialPageRoute(builder: (context) => AchievementsScreen()),
                    );
                  },
                ),
          ),
          ElevatedButton(
            onPressed: () => ref.read(themeNotifierProvider.notifier).changeTheme(),
            child: Icon(Icons.dark_mode),
          ),
          _buildLanguageSwitcher(ref, context),
        ],
      ),
      AppBar(
        title: Text(AppLocalizations.of(context)!.calories_burned_calculator, style: textStyle),
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          ElevatedButton(
            onPressed: () => ref.read(themeNotifierProvider.notifier).changeTheme(),
            child: Icon(Icons.dark_mode),
          ),
          _buildLanguageSwitcher(ref, context),
        ],
      ),
      AppBar(
        title: Text(AppLocalizations.of(context)!.calories_gained_calculator, style: textStyle),
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          ElevatedButton(
            onPressed: () => ref.read(themeNotifierProvider.notifier).changeTheme(),
            child: Icon(Icons.dark_mode),
          ),
          _buildLanguageSwitcher(ref, context),
        ],
      ),
    ];

    return ChangeNotifierProvider(
      create: (context) => HabitProvider(),
      child: MaterialApp(
        locale: locale,
        supportedLocales: [
          Locale('en', 'US'), // English
          Locale('ru', ''),   // Russian
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          appBar: appBars[currentIndex], // Display the selected AppBar
          body: screens[currentIndex], // Display the selected screen
          bottomNavigationBar: Localizations.override(
            context: context, locale: locale,
          child:BottomNavigationBar(
            backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
            selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
            unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor,
            currentIndex: currentIndex,
            onTap: (index) => ref.read(bottomNavIndexProvider.notifier).setIndex(index),
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.notes), label: AppLocalizations.of(context)!.notes),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: AppLocalizations.of(context)!.calendar),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: AppLocalizations.of(context)!.home),
              BottomNavigationBarItem(icon: Icon(Icons.task), label: AppLocalizations.of(context)!.tasks),
              BottomNavigationBarItem(
                  icon: Icon(Icons.local_fire_department_rounded),
                  label: AppLocalizations.of(context)!.sport
              ),
              BottomNavigationBarItem(icon: Icon(Icons.local_dining), label: AppLocalizations.of(context)!.calories),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildLanguageSwitcher(WidgetRef ref, BuildContext context) {
    final currentLocale = ref.watch(localeProvider);

    return PopupMenuButton<Locale>(
      onSelected: (Locale locale) {
        ref.read(localeProvider.notifier).setLocale(locale);
      },
      icon: Icon(Icons.language),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
        PopupMenuItem<Locale>(
          value: Locale('en'),
          child: Text('English'),
        ),
        PopupMenuItem<Locale>(
          value: Locale('ru'),
          child: Text('Русский'),
        ),
      ],
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
                      AppLocalizations.of(context)!.no_notes_habits,
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
                      child: Text(AppLocalizations.of(context)!.add_habit),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddNoteScreen()),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.add_note),
                    ),
                  ],
                ),
              )
                  : ListView(
                children: [
                  if (habits.isNotEmpty) ...[
                    Text(AppLocalizations.of(context)!.habits, style: textStyle),
                    SizedBox(height: 10),
                    ...habits.map((habit) {
                      return HabitCard(habit: habit);
                    }).toList(),
                  ],
                  if (notes.isNotEmpty) ...[
                    SizedBox(height: 20),
                    Text(AppLocalizations.of(context)!.notes, style: textStyle),
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
