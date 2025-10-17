import 'package:flutter/material.dart';

class AuthManager with ChangeNotifier {
  // Internal state to store user data (replace with database/Firebase in a real app)
  final List<Map<String, dynamic>> _users = [
    {'username': 'testuser', 'password': 'password', 'email': 'testuser@email.com'},
    {'username': 'anotheruser', 'password': 'anotherpassword', 'email': 'anotheruser@email.com'}
  ];

  bool _isSignedIn = false;
  String? _currentUsername;

  bool get isSignedIn => _isSignedIn;
  String? get currentUsername => _currentUsername;

  Future<bool> signUp(String username, String password, String email) async {
    // Simulate a sign-up process (replace with actual API calls or database interactions)
    await Future.delayed(const Duration(seconds: 2)); // Simulate a delay

    // Check if the username already exists (in a real app, you'd query a database)
    if (_userExists(username)) {
      return false; // Username already exists
    }

    // Check if the email already exists
    if (_emailExists(email)){
      return false; //Email already exists
    }

    // Simulate successful sign-up
    _users.add({
      'username': username,
      'password': password,
      'email': email,
    });
    notifyListeners(); //Update all the listeners
    return true; // Sign-up successful
  }

  // Sign-in method
  Future<bool> signIn(String username, String password) async {
    // Simulate sign-in (replace with actual authentication logic)
    await Future.delayed(const Duration(seconds: 1));

    // Check if the username and password match
    final user = _users.firstWhere(
          (user) => user['username'] == username && user['password'] == password,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      _isSignedIn = true;
      _currentUsername = username;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
  // Sign-out method
  Future<void> signOut() async {
    _isSignedIn = false;
    _currentUsername = null;
    notifyListeners();
  }

  // Helper function to simulate checking if a username exists (replace with database query)
  bool _userExists(String username) {
    return _users.any((user) => user['username'] == username);
  }

  //Helper function to simulate checking if an email exist
  bool _emailExists(String email){
    return _users.any((user) => user['email'] == email);
  }
}