import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:simplynote/auth/auth_service.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit()
      : authService = GetIt.I<AuthService>(),
        super(LoginInitial());

  final AuthService authService;

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    emit(LoginLoading());
    try {
      await authService.createUserWithEmailAndPassword(email, password);
    } on FirebaseAuthException catch (e) {
      emit(LoginError(e.message ?? ''));
    }

    emit(LoginSuccess());
  }

  Future<void> signIn(String username, String password) async {
    emit(LoginLoading());

    try {
      await authService.signInUser(username, password);
    } on FirebaseAuthException catch (e) {
      emit(LoginError(e.message!));
    }
    emit(LoginSuccess());
  }

  void tryLogin() {
    emit(LoginInitial());
  }
}
