import 'package:flutter/material.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _tasks = [
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

  Future<void> _addTask() async {
    final title = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTaskScreen(),
      ),
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
    }
  }

  Future<void> _editTask(int index) async {
    final updatedTitle = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(
          currentTitle: _tasks[index]['title'],
        ),
      ),
    );

    if (updatedTitle != null && updatedTitle.isNotEmpty) {
      setState(() {
        _tasks[index]['title'] = updatedTitle;
      });
    }
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index]['isCompleted'] = !_tasks[index]['isCompleted'];
    });
  }

  void _deleteTask(int index) {
    final deletedTask = _tasks[index]['title'];

    setState(() {
      _tasks.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$deletedTask deleted'),
      ),
    );
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
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Let’s complete your tasks today.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Today's Tasks",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _tasks.isEmpty
                  ? const Center(
                      child: Text(
                        'No tasks yet.\nAdd your first task!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _tasks.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: 12),
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
