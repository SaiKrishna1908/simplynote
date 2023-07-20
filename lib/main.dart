import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:simplynote/firebase_options.dart';
import 'package:simplynote/home/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
