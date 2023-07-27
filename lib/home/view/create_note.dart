import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simplynote/app_color.dart';
import 'package:simplynote/constants.dart';
import 'package:simplynote/home/cubit/create_note_cubit.dart';
import 'package:simplynote/main.dart';
import 'package:uuid/uuid.dart';

class CreateNote extends StatefulWidget {
  const CreateNote(
      {super.key, this.title, this.content, this.colorId, this.documentId});
  final String? title;
  final String? content;
  final int? colorId;
  final String? documentId;
  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _documentUuid;
  late int _colorId;

  final int apiCallCronTimer = 2;

  bool _showInMarkdown = false;

  Timer? timer;
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController(text: widget.content);
    _documentUuid = widget.documentId ?? const Uuid().v4();
    _colorId = widget.colorId ?? Random().nextInt(Constants.noteColors.length);
    timer = Timer.periodic(
      Duration(seconds: apiCallCronTimer),
      (timer) async {
        if (_titleController.text.isNotEmpty ||
            _contentController.text.isNotEmpty) {
          context.read<CreateNoteCubit>().createNote(
              NoteModel(_documentUuid, _titleController.text,
                  _contentController.text, null, _colorId),
              _documentUuid);
        }
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> deleteNote() async {
    final isDeleted =
        await context.read<CreateNoteCubit>().deleteNote(_documentUuid);
    goRouter.pop();
    if (!mounted) {
      return;
    }
    if (isDeleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColor.appPrimaryColor,
          behavior: SnackBarBehavior.floating,
          content: const Text(
            'Deleted Note',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 200,
            right: 20,
            left: 20,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (Constants.enableMarkDown)
            IconButton(
              onPressed: () => setState(() {
                _showInMarkdown = !_showInMarkdown;
              }),
              icon: FaIcon(
                FontAwesomeIcons.markdown,
                color: _showInMarkdown ? Colors.green : Colors.red,
              ),
            )
          else
            Container(),
          IconButton(
            onPressed: () => deleteNote(),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: BlocBuilder<CreateNoteCubit, CreateNoteState>(
        builder: (context, state) {
          Future<void> storeFunction(NoteModel noteModel) => context
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
    return _showInMarkdown
        ? MarkdownBody(data: _contentController.text)
        : Expanded(
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: _contentController,
              onFieldSubmitted: (value) async {
                await callBack(NoteModel(_documentUuid, _titleController.text,
                    _contentController.text, null, _colorId));
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
    return _showInMarkdown
        ? MarkdownBody(data: _titleController.text)
        : TextFormField(
            controller: _titleController,
            cursorColor: AppColor.appPrimaryColor,
            onFieldSubmitted: (value) => callBack(
              NoteModel(_documentUuid, _titleController.text,
                  _contentController.text, null, _colorId),
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
