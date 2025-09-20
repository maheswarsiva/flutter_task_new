import 'package:flutter/foundation.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository repository;
  bool loading = false;
  String? userId;
  String? error;

  AuthProvider(this.repository) {
    userId = repository.getCurrentUserId();
  }

  Future<bool> signIn(String email, String password) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      userId = await repository.signIn(email, password);
      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      loading = false;
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      userId = await repository.signUp(email, password);
      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      loading = false;
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await repository.signOut();
    userId = null;
    notifyListeners();
  }
}