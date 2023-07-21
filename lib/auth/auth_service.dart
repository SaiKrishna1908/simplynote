import 'package:firebase_auth/firebase_auth.dart';
import 'package:simplynote/auth/login/cubit/login_cubit.dart';

class AuthService {
  AuthService({required this.firebaseAuth});

  final FirebaseAuth firebaseAuth;

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signInUser(String email, String password) async {
    await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }
}
