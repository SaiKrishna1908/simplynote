import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:simplynote/app_color.dart';
import 'package:simplynote/auth/login/cubit/login_cubit.dart';
import 'package:simplynote/auth/login/login_page.dart';
import 'package:simplynote/firebase_options.dart';
import 'package:simplynote/auth/auth_service.dart';
import 'package:simplynote/home/view/create_note.dart';
import 'package:simplynote/home/view/my_home_page.dart';

final goRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => BlocProvider(
        create: (context) => LoginCubit(),
        child: const LoginInView(),
      ),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      path: '/create',
      builder: (context, state) => const CreateNote(),
    )
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final getIt = GetIt.instance;

  final firebaseAuth = FirebaseAuth.instanceFor(app: firebaseApp);
  final authService = AuthService(firebaseAuth: firebaseAuth);
  getIt.registerSingleton<AuthService>(authService);

  runApp(
    MaterialApp.router(
      theme: AppColor.lightMode,
      routerConfig: goRouter,
    ),
  );
}
