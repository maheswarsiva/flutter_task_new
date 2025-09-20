import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return cred.user!.uid;
  }

  Future<String> signUp(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return cred.user!.uid;
  }

  Future<void> signOut() async => await _auth.signOut();

  String? getCurrentUserId() => _auth.currentUser?.uid;
}