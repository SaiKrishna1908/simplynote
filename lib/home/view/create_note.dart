import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:simplynote/app_color.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          children: [titleSection(), hline(), contentSection()],
        ),
      ),
    );
  }

  Widget contentSection() {
    return const Expanded(
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Your Notes',
          hintStyle: TextStyle(
            fontSize: 20,
          ),
        ),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget hline() {
    return const Divider(
      color: AppColor.appSecondaryColor,
      indent: 0,
      endIndent: 0,
      thickness: 0.4,
    );
  }

  Widget titleSection() {
    return const TextField(
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Title',
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.normal,
        ),
      ),
      style: TextStyle(
        fontSize: 25,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w600,
      ),
      cursorHeight: 35,
    );
  }
}
