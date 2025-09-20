import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource datasource;
  AuthRepositoryImpl(this.datasource);

  @override
  Future<String> signIn(String email, String password) => datasource.signIn(email, password);

  @override
  Future<String> signUp(String email, String password) => datasource.signUp(email, password);

  @override
  Future<void> signOut() => datasource.signOut();

  @override
  String? getCurrentUserId() => datasource.getCurrentUserId();
}