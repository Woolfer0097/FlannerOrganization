import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Theme/Theme.dart';
import 'AddNoteScreen.dart';

class Note {
  final String title;
  final String content;
  final List<Task> tasks;

  Note({
    required this.title,
    required this.content,
    required this.tasks,
  });
}

class Task {
  final String title;
  final Color color;

  Task({
    required this.title,
    required this.color,
  });
}

class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier() : super([]);

  void add(Note note) {
    state = [...state, note];
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
  }

  void remove(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i],
    ];
  }
}

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
  return NotesNotifier();
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
                        color: theme.scaffoldBackgroundColor,
                        child: ListTile(
                          title: Text(
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