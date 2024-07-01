import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'NotesScreen.dart';
import 'AddNoteScreen.dart';

class TaskSelectionScreen extends ConsumerStatefulWidget {
  final List<Task> selectedTasks;

  TaskSelectionScreen({required this.selectedTasks});

  @override
  _TaskSelectionScreenState createState() => _TaskSelectionScreenState();
}

class _TaskSelectionScreenState extends ConsumerState<TaskSelectionScreen> {
  late List<Task> tempSelectedTasks;

  @override
  void initState() {
    super.initState();
    tempSelectedTasks = List.from(widget.selectedTasks);
  }

  @override
  Widget build(BuildContext context) {
    final allTasks = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.of(context).pop(tempSelectedTasks);
            },
          ),
        ],
      ),
      body: ListView.builder(
              itemCount: allTasks.length,
              itemBuilder: (context, index) {
                final task = allTasks[index];
                final isSelected = tempSelectedTasks.contains(task);

                return CheckboxListTile(
                title: Text(task.title),
                value: isSelected,
                onChanged: (bool? value) {
                  setState(() {
                  if (value == true) {
                    tempSelectedTasks.add(task);
                    } else {
                      tempSelectedTasks.remove(task);
                    }
                  });
                },
                );
              },
            ),
    );
        
      
  }
}