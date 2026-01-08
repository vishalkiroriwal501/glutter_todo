import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/todo.dart';
import '../providers/todo_provider.dart';

class AddEditTodoScreen extends StatefulWidget {
  final Todo? todo;

  const AddEditTodoScreen({super.key, this.todo});

  @override
  State<AddEditTodoScreen> createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _titleController.text = widget.todo!.title;
      _descriptionController.text = widget.todo!.description;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTodo() async {
    if (_formKey.currentState!.validate()) {
      final todoProvider = Provider.of<TodoProvider>(context, listen: false);

      if (widget.todo == null) {
        // Add new todo
        await todoProvider.addTodo(
          _titleController.text.trim(),
          _descriptionController.text.trim(),
        );
      } else {
        // Update existing todo
        await todoProvider.updateTodo(
          widget.todo!.id,
          _titleController.text.trim(),
          _descriptionController.text.trim(),
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    final isEditing = widget.todo != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Todo' : 'Add Todo'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmDelete(context),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  hintText: 'Enter todo title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                  hintText: 'Enter todo description',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: todoProvider.isLoading ? null : _saveTodo,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: todoProvider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isEditing ? 'Update Todo' : 'Add Todo'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Todo'),
        content: const Text('Are you sure you want to delete this todo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TodoProvider>().deleteTodo(widget.todo!.id);
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close screen
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
