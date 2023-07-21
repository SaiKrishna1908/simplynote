import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simplynote/app_color.dart';
import 'package:simplynote/home/widget/search_bar.dart';
import 'package:simplynote/main.dart';

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
    return Expanded(
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColor.appPrimaryColor,
          fontSize: 40,
          letterSpacing: 0,
          wordSpacing: 0,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: AppColor.appPrimaryColor,
          child: IconButton(
            icon: const Icon(
              Icons.add,
              color: AppColor.appAccentColor,
            ),
            onPressed: () => goRouter.push('/create'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
