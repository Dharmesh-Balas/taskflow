import 'package:flutter/material.dart';

class EditTaskScreen extends StatefulWidget {
  final String currentTitle;
  final String currentCategory;

  const EditTaskScreen({
    super.key,
    required this.currentTitle,
    required this.currentCategory,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _titleController;

  final List<String> _categories = [
    'Personal',
    'Work',
    'Study',
  ];

  late String _selectedCategory;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.currentTitle,
    );

    _selectedCategory = widget.currentCategory;
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

    Navigator.pop(context, {
      'title': title,
      'category': _selectedCategory,
    });
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

            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
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