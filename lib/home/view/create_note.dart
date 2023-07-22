import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplynote/app_color.dart';
import 'package:simplynote/constants.dart';
import 'package:simplynote/home/cubit/create_note_cubit.dart';
import 'package:uuid/uuid.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _documentUuid;
  late int _colorId;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _documentUuid = const Uuid().v4();
    _colorId = Random().nextInt(Constants.noteColors.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<CreateNoteCubit, CreateNoteState>(
        builder: (context, state) {
          storeFunction(NoteModel noteModel) => context
              .read<CreateNoteCubit>()
              .createNote(noteModel, _documentUuid);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              children: [
                titleSection(storeFunction),
                hline(),
                contentSection(storeFunction)
              ],
            ),
          );
        },
      ),
    );
  }

  Widget contentSection(Future<void> Function(NoteModel) callBack) {
    return Expanded(
      child: TextField(
        controller: _contentController,
        onChanged: (value) async {
          await callBack(NoteModel(
              _documentUuid, _titleController.text, value, null, _colorId));
        },
        cursorColor: AppColor.appPrimaryColor,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Your Notes',
          hintStyle: TextStyle(
            fontSize: 20,
          ),
        ),
        style: const TextStyle(
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

  Widget titleSection(Future<void> Function(NoteModel) callBack) {
    return TextField(
      controller: _titleController,
      cursorColor: AppColor.appPrimaryColor,
      onChanged: (value) => callBack(
        NoteModel(
            _documentUuid, value, _contentController.text, null, _colorId),
      ),
      decoration: const InputDecoration(
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
      style: const TextStyle(
        fontSize: 25,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w600,
      ),
      cursorHeight: 35,
    );
  }
}
