import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/task_card.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _tasksKey = 'tasks';

  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTasks = prefs.getString(_tasksKey);

    if (savedTasks != null) {
      final List<dynamic> decodedTasks = jsonDecode(savedTasks);

      setState(() {
        _tasks = decodedTasks.map((task) {
          return {
            'title': task['title'],
            'subtitle': task['subtitle'],
            'icon': _getIcon(task['icon']),
            'isCompleted': task['isCompleted'],
          };
        }).toList();
      });
    } else {
      setState(() {
        _tasks = [
          {
            'title': 'Learn Flutter',
            'subtitle': 'Practice widgets',
            'icon': Icons.code,
            'isCompleted': false,
          },
          {
            'title': 'Build TaskFlow UI',
            'subtitle': 'Create home screen',
            'icon': Icons.design_services,
            'isCompleted': false,
          },
          {
            'title': 'Push to GitHub',
            'subtitle': 'Save today’s progress',
            'icon': Icons.cloud_upload,
            'isCompleted': false,
          },
        ];
      });

      await _saveTasks();
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();

    final tasksToSave = _tasks.map((task) {
      return {
        'title': task['title'],
        'subtitle': task['subtitle'],
        'icon': _getIconName(task['icon']),
        'isCompleted': task['isCompleted'],
      };
    }).toList();

    await prefs.setString(_tasksKey, jsonEncode(tasksToSave));
  }

  String _getIconName(IconData icon) {
    if (icon == Icons.code) {
      return 'code';
    } else if (icon == Icons.design_services) {
      return 'design_services';
    } else if (icon == Icons.cloud_upload) {
      return 'cloud_upload';
    } else {
      return 'task_alt';
    }
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'code':
        return Icons.code;
      case 'design_services':
        return Icons.design_services;
      case 'cloud_upload':
        return Icons.cloud_upload;
      default:
        return Icons.task_alt;
    }
  }

  Future<void> _addTask() async {
    final title = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );

    if (title != null && title.isNotEmpty) {
      setState(() {
        _tasks.add({
          'title': title,
          'subtitle': 'New task',
          'icon': Icons.task_alt,
          'isCompleted': false,
        });
      });

      await _saveTasks();
    }
  }

  Future<void> _editTask(int index) async {
    final updatedTitle = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditTaskScreen(currentTitle: _tasks[index]['title']),
      ),
    );

    if (updatedTitle != null && updatedTitle.isNotEmpty) {
      setState(() {
        _tasks[index]['title'] = updatedTitle;
      });

      await _saveTasks();
    }
  }

  Future<void> _toggleTask(int index) async {
    setState(() {
      _tasks[index]['isCompleted'] = !_tasks[index]['isCompleted'];
    });

    await _saveTasks();
  }

  Future<void> _deleteTask(int index) async {
    final deletedTask = _tasks[index]['title'];

    setState(() {
      _tasks.removeAt(index);
    });

    await _saveTasks();
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$deletedTask deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TaskFlow',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back 👋',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Let’s complete your tasks today.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text(
              "Today's Tasks",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _tasks.isEmpty
                  ? const Center(
                      child: Text(
                        'No tasks yet.\nAdd your first task!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _tasks.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final task = _tasks[index];

                        return TaskCard(
                          title: task['title'],
                          subtitle: task['subtitle'],
                          icon: task['icon'],
                          isCompleted: task['isCompleted'],
                          onToggle: () => _toggleTask(index),
                          onEdit: () => _editTask(index),
                          onDelete: () => _deleteTask(index),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _addTask,
                icon: const Icon(Icons.add),
                label: const Text('Add New Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
