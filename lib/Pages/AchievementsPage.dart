import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'HabitsScreen.dart';
import 'Theme/Theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AchievementsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.achievements),
      ),
      body: Consumer<HabitProvider>(
        builder: (context, habitProvider, child) {
          List<Achievement> achievements = habitProvider.achievements;
          return ListView.builder(
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              Achievement achievement = achievements[index];
              return ListTile(
                title: Text(achievement.title),
                subtitle: Text(achievement.description),
                trailing: Text(DateFormat.yMMMd().format(achievement.dateAchieved)),
              );
            },
          );
        },
      ),
    );
  }
}
