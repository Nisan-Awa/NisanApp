import 'package:flutter/material.dart';

// --- Task Model ---
class Task {
  String title;
  String description;
  DateTime dueDate;
  int priority;
  String category;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.category,
    this.isCompleted = false,
  });
}

// --- SortOption Enum ---
enum SortOption {
  dueDate,
  priority,
  category,
}

// --- TaskManager (ChangeNotifier) ---
class TaskManager extends ChangeNotifier {
  List<Task> _tasks = [];
  List<String> allCategories = ["Work", "Personal", "Shopping"]; // Default categories
  SortOption _sortOption = SortOption.dueDate;
  String _filterCategory = "All";
  bool _showCompleted = false; // false: Show all; true: show *only* completed

  List<Task> get tasks => _tasks;
  SortOption get sortOption => _sortOption;
  String get filterCategory => _filterCategory;
  bool get showCompleted => _showCompleted;

  set sortOption(SortOption option) {
    _sortOption = option;
    _sortTasks();
    notifyListeners();
  }

  set filterCategory(String category) {
    _filterCategory = category;
    notifyListeners();
  }

  set showCompleted(bool value) {
    _showCompleted = value;
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    _sortTasks();
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void clearCompletedTasks() {
    _tasks.removeWhere((task) => task.isCompleted);
    notifyListeners();
  }

  // IMPORTANT:  This is the core filtering logic.
  List<Task> get filteredTasks {
    List<Task> filtered = _tasks;

    // Apply category filter
    if (_filterCategory != "All") {
      filtered = filtered.where((task) => task.category == _filterCategory).toList();
    }

    // Apply showCompleted filter
    if (_showCompleted) {
      filtered = filtered.where((task) => task.isCompleted).toList(); // Show ONLY completed
    }
    // No 'else' needed.  If _showCompleted is false, we just use the category-filtered list.

    return filtered;
  }

  void _sortTasks() {
    switch (_sortOption) {
      case SortOption.dueDate:
        _tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
      case SortOption.priority:
        _tasks.sort((a, b) => b.priority.compareTo(a.priority)); // High to low
        break;
      case SortOption.category:
        _tasks.sort((a, b) => a.category.compareTo(b.category));
        break;
    }
  }
}
