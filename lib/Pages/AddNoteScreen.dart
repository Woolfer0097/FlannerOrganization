import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'NotesScreen.dart';
import 'TaskSelectionScreen.dart';
import 'HabbitsScreen.dart';

final habitProviderProvider = ChangeNotifierProvider((ref) => HabitProvider());

final tasksProvider = Provider<List<Task>>((ref) {
  final habitProvider = ref.watch(habitProviderProvider); 

  List<Task> tasks = habitProvider.habits.map((habit) {
    return Task(
      title: habit.title,
      color: Colors.purple, 
    );
  }).toList();

  List<Task> _completedTasks = habitProvider.achievements.map((habit) {
    return Task(color: Colors.purple.shade800, title: habit.title);
  }).toList();

  tasks.addAll(_completedTasks);

  return tasks;
});

class AddNoteScreen extends ConsumerStatefulWidget {
  final int? noteIndex;

  AddNoteScreen({this.noteIndex});

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends ConsumerState<AddNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  List<Task> selectedTasks = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();

    if (widget.noteIndex != null) {
      final note = ref.read(notesProvider)[widget.noteIndex!];
      _titleController.text = note.title;
      _contentController.text = note.content;
      selectedTasks = note.tasks;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteIndex == null ? 'Add Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_task),
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TaskSelectionScreen(selectedTasks: selectedTasks),
                ),
              );
              if (result != null) {
                setState(() {
                  selectedTasks = result;
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Title',
                border: InputBorder.none, // No border for title
              ),
              style: TextStyle(fontSize: 24.0), // Larger font for title
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 200, // Minimum height to show the text area
                      ),
                      child: IntrinsicHeight(
                        child: TextField(
                          controller: _contentController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Content', // Placeholder text
                            border: InputBorder.none, // No border for content
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Text('Selected Tasks:'),
            Wrap(
              spacing: 8.0,
              children: selectedTasks.map((task) {
                return Chip(
                  label: Text(
                    task.title,
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: task.color,
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final String title = _titleController.text;
                    final String content = _contentController.text;
                    if (title.isNotEmpty && content.isNotEmpty) {
                      if (widget.noteIndex == null) {
                        ref.read(notesProvider.notifier).add(Note(
                          title: title,
                          content: content,
                          tasks: selectedTasks,
                        ));
                      } else {
                        ref.read(notesProvider.notifier).edit(
                          widget.noteIndex!,
                          title,
                          content,
                          selectedTasks,
                        );
                      }
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(widget.noteIndex == null ? 'Add Note' : 'Save Changes'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
