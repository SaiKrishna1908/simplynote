import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplynote/auth/auth_service.dart';
import 'package:simplynote/constants.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit()
      : authService = GetIt.I<AuthService>(),
        super(LoginInitial());

  final AuthService authService;

  Future<void> isUserLoggedIn() async {
    final isUserLoggedIn = await authService.isUserLoggedIn();
    if (isUserLoggedIn) {
      emit(LoginSuccess());
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    emit(LoginLoading());
    try {
      final creds =
          await authService.createUserWithEmailAndPassword(email, password);
      await _setPref(Constants.uid, creds.user!.uid);
    } on FirebaseAuthException catch (e) {
      emit(LoginError(e.message ?? ''));
      return;
    }

    emit(LoginSuccess());
  }

  Future<void> signIn(String username, String password) async {
    emit(LoginLoading());

    try {
      final creds = await authService.signInUser(username, password);
      await _setPref(Constants.uid, creds.user!.uid);
    } on FirebaseAuthException catch (e) {
      emit(LoginError(e.message!));
      return;
    }
    emit(LoginSuccess());
  }

  Future<void> _setPref<T>(String key, T value) async {
    final sp = GetIt.I<SharedPreferences>();
    if (T == String) {
      await sp.setString(key, value as String);
    } else if (T == int) {
      await sp.setInt(key, value as int);
    } else if (T == double) {
      await sp.setDouble(key, value as double);
    } else if (T == bool) {
      await sp.setBool(key, value as bool);
    }
  }

  void tryLogin() {
    emit(LoginInitial());
  }
}
