import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:json_theme/json_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplynote/app_color.dart';
import 'package:simplynote/auth/login/cubit/login_cubit.dart';
import 'package:simplynote/auth/login/login_page.dart';
import 'package:simplynote/firebase_options.dart';
import 'package:simplynote/auth/auth_service.dart';
import 'package:simplynote/home/view/create_note.dart';
import 'package:simplynote/home/view/cubit/create_note_cubit.dart';
import 'package:simplynote/home/view/cubit/my_home_page_cubit.dart';
import 'package:simplynote/home/view/my_home_page.dart';

final goRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => BlocProvider(
        create: (context) => LoginCubit()..isUserLoggedIn(),
        child: const LoginInView(),
      ),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => BlocProvider(
        create: (context) => MyHomePageCubit(),
        child: const MyHomePage(),
      ),
    ),
    GoRoute(
      path: '/create',
      builder: (context, state) => BlocProvider(
        create: (context) => CreateNoteCubit(),
        child: CreateNote(),
      ),
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

  final sp = await SharedPreferences.getInstance();

  getIt.registerSingleton<AuthService>(authService);
  getIt.registerSingleton<SharedPreferences>(sp);

  runApp(
    MaterialApp.router(
      theme: AppColor.lightMode,
      routerConfig: goRouter,
    ),
  );
}
