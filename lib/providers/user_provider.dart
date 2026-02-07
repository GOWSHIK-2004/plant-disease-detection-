import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/plant.dart';
import '../models/scan_result.dart';

class UserProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  User? _currentUser;
  static const String _currentUserKey = 'current_user';
  static const String _registeredUsersKey = 'registered_users';
  static const String _scanHistoryKey = 'scan_history';

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _currentUser?.username;

  List<Plant> _selectedPlants = [];
  bool _hasSelectedPlants = false;

  bool get hasSelectedPlants => _hasSelectedPlants;
  List<Plant> get selectedPlants => _selectedPlants;

  List<ScanResult> _scanHistory = [];
  List<ScanResult> get scanHistory => List.unmodifiable(_scanHistory);

  // Add callback for chat history management
  VoidCallback? onLogout;
  VoidCallback? onLogin;

  Future<void> setSelectedPlants(List<Plant> plants) async {
    _selectedPlants = plants;
    _hasSelectedPlants = plants.isNotEmpty;
    // TODO: Store plants in local storage
    notifyListeners();
  }

  Future<void> addScanResult(ScanResult result) async {
    _scanHistory.insert(0, result); // Add to beginning of list
    if (_scanHistory.length > 20) { // Keep only last 20 scans
      _scanHistory = _scanHistory.sublist(0, 20);
    }
    await _saveScanHistory();
    notifyListeners();
  }

  Future<void> _saveScanHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = _scanHistory.map((scan) => jsonEncode(scan.toJson())).toList();
    await prefs.setStringList(_scanHistoryKey, historyJson);
  }

  Future<void> loadScanHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_scanHistoryKey) ?? [];
    _scanHistory = historyJson
        .map((json) => ScanResult.fromJson(jsonDecode(json)))
        .toList();
    notifyListeners();
  }

  Future<void> clearScanHistory() async {
    _scanHistory.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scanHistoryKey);
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString(_currentUserKey);
    if (userStr != null) {
      _currentUser = User.fromJson(jsonDecode(userStr));
      _isLoggedIn = true;
      await loadScanHistory();
      onLogin?.call(); // Call login callback instead of direct ChatProvider access
      notifyListeners();
    }
  }

  Future<bool> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> users = prefs.getStringList(_registeredUsersKey) ?? [];
    
    // Check if user already exists
    if (users.any((userStr) => 
        jsonDecode(userStr)['username'] == username)) {
      return false;
    }

    // Create new user
    final newUser = User(username: username, password: password);
    users.add(jsonEncode(newUser.toJson()));
    
    // Save to SharedPreferences
    await prefs.setStringList(_registeredUsersKey, users);
    await prefs.setString(_currentUserKey, jsonEncode(newUser.toJson()));
    
    _currentUser = newUser;
    _isLoggedIn = true;
    notifyListeners();
    return true;
  }

  Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> users = prefs.getStringList(_registeredUsersKey) ?? [];
    
    // Find user
    for (String userStr in users) {
      final userData = jsonDecode(userStr);
      if (userData['username'] == username && 
          userData['password'] == password) {
        _currentUser = User.fromJson(userData);
        _isLoggedIn = true;
        await prefs.setString(_currentUserKey, userStr);
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
    _currentUser = null;
    _isLoggedIn = false;
    await clearScanHistory();
    onLogout?.call(); // Call logout callback instead of direct ChatProvider access
    notifyListeners();
  }
}
