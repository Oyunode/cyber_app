import 'package:flutter/material.dart';

class UserProfile {
  final String username;
  final String password; // Зөвхөн тоглоомын зорилгоор хадгалж байна
  int totalScore;

  UserProfile({
    required this.username,
    required this.password,
    this.totalScore = 0,
  });
}

class AppState extends ChangeNotifier {
  UserProfile? currentUser;
  final List<UserProfile> _users = [];

  List<UserProfile> get leaderboard {
    final copy = [..._users];
    copy.sort((a, b) => b.totalScore.compareTo(a.totalScore));
    return copy;
  }

  bool usernameExists(String username) {
    return _users.any((u) => u.username == username);
  }

  /// Бүртгэл үүсгэх. Амжилттай бол true, хэрэглэгчийн нэр давхцвал false.
  bool register(String username, String password) {
    username = username.trim();
    if (username.isEmpty || password.isEmpty) return false;
    if (usernameExists(username)) return false;

    final user = UserProfile(
      username: username,
      password: password,
    );
    _users.add(user);
    currentUser = user;
    notifyListeners();
    return true;
  }

  /// Нэвтрэх. Амжилттай бол true.
  bool login(String username, String password) {
    username = username.trim();
    if (username.isEmpty || password.isEmpty) return false;

    final user = _users.firstWhere(
      (u) => u.username == username && u.password == password,
      orElse: () => UserProfile(username: '', password: ''),
    );

    if (user.username.isEmpty) {
      return false;
    }
    currentUser = user;
    notifyListeners();
    return true;
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }

  void addScore(int points) {
    if (currentUser == null) return;
    currentUser!.totalScore += points;
    notifyListeners();
  }
}

// global
final appState = AppState();
