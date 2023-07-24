import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplynote/constants.dart';

class AuthService {
  AuthService({required this.firebaseAuth});

  final FirebaseAuth firebaseAuth;

  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) async {
    return firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInUser(String email, String password) async {
    return await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<bool> isUserLoggedIn() async {
    return (GetIt.I<SharedPreferences>().containsKey(Constants.uid) &&
        firebaseAuth.currentUser != null);
  }

  Future<void> signOut() async {
    await GetIt.I<SharedPreferences>().clear();
    await firebaseAuth.signOut();
  }
}
