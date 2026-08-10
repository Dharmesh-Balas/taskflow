import 'package:flutter/material.dart';

class EditTaskScreen extends StatefulWidget {
  final String currentTitle;

  const EditTaskScreen({
    super.key,
    required this.currentTitle,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.currentTitle,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _updateTask() {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a task title'),
        ),
      );
      return;
    }

    Navigator.pop(context, title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _updateTask(),
              decoration: const InputDecoration(
                labelText: 'Task title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _updateTask,
              icon: const Icon(Icons.save),
              label: const Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}
