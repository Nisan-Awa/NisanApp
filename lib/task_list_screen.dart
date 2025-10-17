import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_manager.dart'; // Import TaskManager
import 'auth_manager.dart'; // Import AuthManager

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        actions: [
          // Category Filter
          PopupMenuButton<String>(
            onSelected: (String category) {
              Provider.of<TaskManager>(context, listen: false).filterCategory = category;
            },
            itemBuilder: (BuildContext context) {
              return ["All", ...Provider.of<TaskManager>(context).allCategories] // Include "All" option
                  .map((String category) {
                return PopupMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList();
            },
            icon: const Icon(Icons.filter_list),
          ),
          // Sort Option
          PopupMenuButton<SortOption>(
            onSelected: (SortOption option) {
              Provider.of<TaskManager>(context, listen: false).sortOption = option;
            },
            itemBuilder: (BuildContext context) {
              return SortOption.values.map((SortOption option) {
                return PopupMenuItem<SortOption>(
                  value: option,
                  child: Text(option.toString().split('.').last),
                );
              }).toList();
            },
            icon: const Icon(Icons.sort),
          ),
          // Show/Hide Completed
          PopupMenuButton<int>( // Use int for multiple options
            onSelected: (int value) {
              if (value == 0) {
                Provider.of<TaskManager>(context, listen: false).showCompleted = false; // All
              } else if (value == 1) {
                Provider.of<TaskManager>(context, listen: false).showCompleted = true; // Show Completed
              } else {
                Provider.of<TaskManager>(context, listen: false).showCompleted = false; // Hide Completed
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(value: 0, child: Text("All")),
                const PopupMenuItem(value: 1, child: Text("Show Completed")),
                const PopupMenuItem(value: 2, child: Text("Hide Completed")), // Keep this option
              ];
            },
            icon: const Icon(Icons.done_all),
          ),
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthManager>(context, listen: false).signOut(); // Sign out
              // No need for pushNamedAndRemoveUntil, we handle navigation in main.dart
            },
          ),
        ],
      ),
      body: Consumer<TaskManager>( // Use Consumer to listen for changes
        builder: (context, taskManager, child) {
          return ListView.builder(
            itemCount: taskManager.filteredTasks.length, // Use filteredTasks
            itemBuilder: (context, index) {
              final task = taskManager.filteredTasks[index];
              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
                trailing: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    task.isCompleted = value ?? false;
                    taskManager.notifyListeners(); // Update UI
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Example: Add a dummy task.  Replace with your add task logic.
          Provider.of<TaskManager>(context, listen: false).addTask(
            Task(
              title: "New Task ${DateTime.now()}",
              description: "Description",
              dueDate: DateTime.now().add(const Duration(days: 2)),
              priority: 1,
              category: "Work",
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}