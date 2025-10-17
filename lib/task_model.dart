// lib/task_model.dart
class Task {
  String id; // Unique identifier
  String title;
  String? description; // Optional description
  DateTime? dueDate;  // Optional due date
  int priority;
  String category;
  bool isComplete;
  DateTime creationTimestamp; // Add creation timestamp

  Task({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    required this.priority,
    required this.category,
    this.isComplete = false,
    required this.creationTimestamp, // Include in constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(), // Handle null
      'priority': priority,
      'category': category,
      'isComplete': isComplete,
      'creationTimestamp': creationTimestamp.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '', // Provide default values for safety
      title: map['title'] ?? '',
      description: map['description'],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      priority: map['priority'] ?? 0, // Provide a default
      category: map['category'] ?? '',
      isComplete: map['isComplete'] ?? false,
      creationTimestamp: DateTime.parse(map['creationTimestamp'] ?? DateTime.now().toIso8601String()),
    );
  }
}

enum SortOption { dueDate, priority, category }

enum CompletedFilter { all, showCompleted, hideCompleted }