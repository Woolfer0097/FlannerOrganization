import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Theme/Theme.dart';
import 'AddNoteScreen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Note {
  final String title;
  final String content;
  final List<Task> tasks;

  Note({
    required this.title,
    required this.content,
    required this.tasks,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'tasks': tasks.map((task) => task.toMap()).toList(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'],
      content: map['content'],
      tasks: List<Task>.from(map['tasks']?.map((x) => Task.fromMap(x))),
    );
  }
}

class Task {
  final String title;
  final Color color;

  Task({
    required this.title,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'color': color.value,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      color: Color(map['color']),
    );
  }
}

class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier() : super([]);

  Future<void> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesString = prefs.getString('notes');
    if (notesString != null) {
      final List<dynamic> notesList = json.decode(notesString);
      state = notesList.map((noteMap) => Note.fromMap(noteMap)).toList();
    }
  }

  Future<void> saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesString = json.encode(state.map((note) => note.toMap()).toList());
    await prefs.setString('notes', notesString);
  }

  void add(Note note) {
    state = [note, ...state];
    saveNotes();
  }

  void edit(int index, String title, String content, List<Task> tasks) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          Note(
            title: title,
            content: content,
            tasks: tasks,
          )
        else
          state[i],
    ];
    saveNotes();
  }

  void remove(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i],
    ];
    saveNotes();
  }
}

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
  return NotesNotifier()..loadNotes();
});

class NotesScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);
    final theme = ref.watch(themeNotifierProvider);
    final textStyle = TextStyle(
      color: theme.appBarTheme.titleTextStyle?.color,
    );

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddNoteScreen(noteIndex: index),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: theme.cardColor,
                        child: ListTile(
                          title: Text(
                            maxLines: 1,
                            note.title,
                            style: textStyle,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.content,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textStyle,
                              ),
                              SizedBox(height: 8.0),
                              Wrap(
                                children: note.tasks.map((task) {
                                  return Chip(
                                    label: Text(
                                      task.title,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: task.color,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              ref.read(notesProvider.notifier).remove(index);
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddNoteScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  NoteCard({
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        title: Text(
          note.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.0),
            Wrap(
              children: note.tasks.map((task) {
                return Chip(
                  label: Text(task.title),
                  backgroundColor: task.color,
                );
              }).toList(),
            ),
          ],
        ),
        onTap: onTap,
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
