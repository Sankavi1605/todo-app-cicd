// lib/main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const ToDoListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({super.key});

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  // A list to store the to-do items
  final List<String> _tasks = [];
  // A controller for the text field
  final TextEditingController _textFieldController = TextEditingController();

  // Function to add a new task
  void _addTask(String task) {
    // Only add non-empty tasks
    if (task.isNotEmpty) {
      setState(() {
        _tasks.add(task);
      });
      _textFieldController.clear(); // Clear the text field after adding
    }
  }

  // Function to remove a task
  void _removeTask(int index) {
    setState(() {
        _tasks.removeAt(index);
    });
  }

  // Function to show the dialog for adding a task
  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a new task'),
          content: TextField(
            controller: _textFieldController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter task here...'),
            onSubmitted: (value) {
                _addTask(value);
                Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('ADD'),
              onPressed: () {
                _addTask(_textFieldController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter To-Do App'),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_tasks[index]),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _removeTask(index),
              tooltip: 'Delete Task',
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}