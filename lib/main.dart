import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplynote/app_color.dart';
import 'package:simplynote/auth/auth_service.dart';
import 'package:simplynote/auth/login/cubit/login_cubit.dart';
import 'package:simplynote/auth/login/login_page.dart';
import 'package:simplynote/constants.dart';
import 'package:simplynote/firebase_options.dart';
import 'package:simplynote/home/cubit/create_note_cubit.dart';
import 'package:simplynote/home/cubit/my_home_page_cubit.dart';
import 'package:simplynote/home/model/note.dart';
import 'package:simplynote/home/view/create_note.dart';
import 'package:simplynote/home/view/my_home_page.dart';

import 'package:simplynote/storage_service.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';

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
        create: (context) => CreateNoteCubit(
          NoteModel(
            Constants.emptyString,
            Constants.emptyString,
            Constants.emptyString,
            null,
            1,
            [],
            [],
            DateTime.now().millisecondsSinceEpoch,
            false,
          ),
        ),
        child: const CreateNote(),
      ),
    ),
    GoRoute(
      path: '/edit/:uuid',
      name: 'edit',
      builder: (context, state) {
        final noteModel = state.extra as NoteModel;
        return BlocProvider(
          create: (context) {
            return CreateNoteCubit(
              NoteModel(
                noteModel.uuid,
                noteModel.title,
                noteModel.content,
                noteModel.firestoreId,
                noteModel.colorId,
                noteModel.titleDeltaMap,
                noteModel.contentDeltaMap,
                noteModel.lastAccessedEpoch,
                noteModel.isDeleted,
              ),
            );
          },
          child: CreateNote(
            title: noteModel.title,
            content: noteModel.content,
            colorId: noteModel.colorId,
            documentId: noteModel.uuid,
            titleDelta: Delta.fromJson(noteModel.titleDeltaMap),
            contentDelta: Delta.fromJson(noteModel.contentDeltaMap),
            noteFlow: NoteFlow.edit,
          ),
        );
      },
    ),
  ],
);

/*

  Does not work for IOS, TODO configure for iOS

@pragma('vm:entry-point')
Future<void> callbackDispatcher() async {
  final authService = GetIt.I<AuthService>();
  Workmanager().executeTask(
    (task, inputData) async {
      if (await authService.isUserLoggedIn()) {
        try {
          await StorageService.sync(
            GetIt.I<StorageService>(
                instanceName: StorageOptions.firebaseDatabase.name),
            GetIt.I<StorageService>(
              instanceName: StorageOptions.hiveDatabase.name,
            ),
          );
        } on Exception catch (e) {
          log(e.toString());
          return Future.value(false);
        }
      } else {
        debugPrint('Cannot sync, no logged in user');
      }
      return Future.value(true);
    },
  );
}

*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final getIt = GetIt.instance;

  final firebaseAuth = FirebaseAuth.instanceFor(app: firebaseApp);
  final authService = AuthService(firebaseAuth: firebaseAuth);

  final sp = await SharedPreferences.getInstance();

  await Hive.initFlutter();
  Hive.registerAdapter(NoteModelAdapter());
  final notesBox = await Hive.openBox<NoteModel>('notes');

  getIt.registerSingleton<AuthService>(authService);
  getIt.registerSingleton<SharedPreferences>(sp);
  getIt.registerSingleton<StorageService>(
    FirebaseStorage(),
    instanceName: StorageOptions.firebaseDatabase.name,
  );
  getIt.registerSingleton<StorageService>(HiveStorage(),
      instanceName: StorageOptions.hiveDatabase.name);
  getIt.registerSingleton<Box<NoteModel>>(notesBox);

  // Workmanager().initialize(callbackDispatcher, isInDebugMode: !kReleaseMode);

  // Workmanager().registerPeriodicTask(
  //   backoffPolicy: BackoffPolicy.linear,
  //   const Uuid().v4(),
  //   'task_sync',
  //   frequency: const Duration(minutes: 15),
  // );

  runApp(
    MaterialApp.router(
      theme: AppColor.lightMode,
      routerConfig: goRouter,
    ),
  );
}
