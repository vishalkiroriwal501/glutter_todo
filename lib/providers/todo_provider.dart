import 'package:flutter/material.dart';

import '../models/todo.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];
  bool _isLoading = false;

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;
  List<Todo> get completedTodos =>
      _todos.where((todo) => todo.isCompleted).toList();
  List<Todo> get pendingTodos =>
      _todos.where((todo) => !todo.isCompleted).toList();

  // Mock data loading - in real app, this would fetch from API
  Future<void> loadTodos() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock todos
    _todos = [
      Todo(
        id: '1',
        title: 'Welcome to Todo App',
        description: 'This is your first todo item. You can edit or delete it.',
      ),
      Todo(
        id: '2',
        title: 'Add a new todo',
        description: 'Tap the + button to create a new todo item.',
        isCompleted: true,
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTodo(String title, String description) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
    );

    _todos.add(newTodo);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateTodo(String id, String title, String description) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(
        title: title,
        description: description,
        updatedAt: DateTime.now(),
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleTodoCompletion(String id) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(
        isCompleted: !_todos[index].isCompleted,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  Future<void> deleteTodo(String id) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    _todos.removeWhere((todo) => todo.id == id);
    _isLoading = false;
    notifyListeners();
  }
}
