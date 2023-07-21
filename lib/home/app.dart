import 'package:flutter/material.dart';
import 'package:simplynote/app_color.dart';
import 'package:simplynote/auth/login/login_page.dart';
import 'package:simplynote/home/search_bar.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget _gap() {
    return const SizedBox(
      height: 30,
    );
  }

  Widget titleWidget(String title) {
    final theme = Theme.of(context);
    return Expanded(
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColor.appPrimaryColor,
          fontSize: 40,
          letterSpacing: 0.1,
          wordSpacing: 0.5,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SearchBar(
              searchCallback: (s) => debugPrint(s),
            ),
            _gap(),
            titleWidget('Your Notes'),
          ],
        ),
      ),
    );
  }
}
