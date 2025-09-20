import '../repositories/auth_repository.dart';

class AuthUseCases {
  final AuthRepository repository;
  AuthUseCases(this.repository);

  Future<String> signIn(String email, String password) => repository.signIn(email, password);
  Future<String> signUp(String email, String password) => repository.signUp(email, password);
  Future<void> signOut() => repository.signOut();
  String? currentUserId() => repository.getCurrentUserId();
}