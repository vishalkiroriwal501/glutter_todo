import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/todo.dart';
import '../providers/auth_provider.dart';
import '../providers/todo_provider.dart';
import 'add_edit_todo_screen.dart';
import 'login_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  void initState() {
    super.initState();
    // Load todos when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodoProvider>().loadTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: todoProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : todoProvider.todos.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.checklist, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No todos yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      Text(
                        'Tap + to add your first todo',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: todoProvider.todos.length,
                  itemBuilder: (context, index) {
                    final todo = todoProvider.todos[index];
                    return TodoItem(
                      todo: todo,
                      onToggle: () =>
                          todoProvider.toggleTodoCompletion(todo.id),
                      onEdit: () => _editTodo(context, todo),
                      onDelete: () => _deleteTodo(context, todo),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTodo(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTodo(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddEditTodoScreen()),
    );
  }

  void _editTodo(BuildContext context, Todo todo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddEditTodoScreen(todo: todo),
      ),
    );
  }

  void _deleteTodo(BuildContext context, Todo todo) {
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
              context.read<TodoProvider>().deleteTodo(todo.id);
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: todo.isCompleted ? Colors.grey : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (todo.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                todo.description,
                style: TextStyle(
                  color: todo.isCompleted ? Colors.grey : Colors.grey[600],
                ),
              ),
            ],
            const SizedBox(height: 4),
            Text(
              'Created: ${_formatDate(todo.createdAt)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
        onTap: onToggle,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
