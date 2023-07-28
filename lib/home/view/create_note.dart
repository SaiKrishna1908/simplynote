import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:simplynote/app_color.dart';
import 'package:simplynote/constants.dart';
import 'package:simplynote/home/cubit/create_note_cubit.dart';
import 'package:simplynote/main.dart';
import 'package:uuid/uuid.dart';

class CreateNote extends StatefulWidget {
  const CreateNote(
      {super.key,
      this.title,
      this.content,
      this.colorId,
      this.documentId,
      this.titleDelta,
      this.contentDelta,
      this.noteFlow = NoteFlow.create});
  final String? title;
  final String? content;
  final int? colorId;
  final String? documentId;
  final quill.Delta? titleDelta;
  final quill.Delta? contentDelta;

  final NoteFlow noteFlow;
  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  late quill.QuillController _titleController;
  late quill.QuillController _contentController;
  late String _documentUuid;
  late int _colorId;

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();

  final int apiCallCronTimer = 2;

  Timer? timer;

  bool _showtoolBar = false;

  Widget _buildSimpleNoteToolbar() {
    return quill.QuillToolbar.basic(
      controller: _titleFocusNode.hasPrimaryFocus
          ? _titleController
          : _contentController,
      showFontFamily: false,
      showClearFormat: false,
      showStrikeThrough: false,
      showInlineCode: false,
      showImageButton: false,
      showVideoButton: false,
      showFontSize: false,
      showLink: false,
      showJustifyAlignment: false,
      showUnderLineButton: false,
      showCameraButton: false,
      showLeftAlignment: false,
      showRightAlignment: false,
      showListNumbers: false,
      showQuote: false,
      showIndent: false,
      multiRowsDisplay: false,
      iconTheme: const quill.QuillIconTheme(borderRadius: 10),
      dialogTheme: quill.QuillDialogTheme(
        dialogBackgroundColor: AppColor.appAccentColor,
      ),
    );
  }

  Widget _buildTitleWidget() {
    return quill.QuillEditor(
      autoFocus: true,
      controller: _titleController,
      expands: false,
      focusNode: _titleFocusNode,
      scrollController: ScrollController(),
      padding: EdgeInsets.zero,
      readOnly: false,
      scrollable: false,
      placeholder: 'Give your note a title',
    );
  }

  Widget _buildContentWidget() {
    return quill.QuillEditor(
      autoFocus: false,
      controller: _contentController,
      expands: true,
      focusNode: _contentFocusNode,
      scrollController: ScrollController(),
      padding: EdgeInsets.zero,
      readOnly: false,
      scrollable: true,
      placeholder: 'Your Notes',
    );
  }

  @override
  void initState() {
    super.initState();
    _titleController = widget.titleDelta == null
        ? quill.QuillController.basic()
        : quill.QuillController(
            document: quill.Document.fromDelta(widget.titleDelta!),
            selection: const TextSelection.collapsed(offset: 0));
    _contentController = widget.contentDelta == null
        ? quill.QuillController.basic()
        : quill.QuillController(
            document: quill.Document.fromDelta(widget.contentDelta!),
            selection: const TextSelection.collapsed(offset: 0));
    _documentUuid = widget.documentId ?? const Uuid().v4();
    _colorId = widget.colorId ?? Random().nextInt(Constants.noteColors.length);

    _titleFocusNode.addListener(() {
      setState(() {});
    });

    _contentFocusNode.addListener(() {
      setState(() {});
    });
    timer = Timer.periodic(
      Duration(seconds: apiCallCronTimer),
      (timer) async {
        if (!_titleController.document.isEmpty() ||
            !_contentController.document.isEmpty()) {
          context.read<CreateNoteCubit>().createNote(
                NoteModel(
                    _documentUuid,
                    _titleController.document.toPlainText(),
                    _contentController.document.toPlainText(),
                    null,
                    _colorId,
                    _titleController.document.toDelta(),
                    _contentController.document.toDelta()),
                _documentUuid,
              );
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
        title: Text(
          widget.noteFlow == NoteFlow.create ? 'Create Note' : 'Edit Note',
          style: TextStyle(
            color: AppColor.lighten(
              AppColor.appPrimaryColor,
              0.2,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => setState(
              () {
                _showtoolBar = !_showtoolBar;
              },
            ),
            icon: const Icon(
              Icons.expand_sharp,
            ),
          ),
          IconButton(
            onPressed: () => deleteNote(),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: BlocBuilder<CreateNoteCubit, CreateNoteState>(
        builder: (context, state) {
          // Future<void> storeFunction(NoteModel noteModel) => context
          //     .read<CreateNoteCubit>()
          //     .createNote(noteModel, _documentUuid);
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Column(
                children: [
                  if (_showtoolBar)
                    Column(children: [
                      _buildSimpleNoteToolbar(),
                      const SizedBox(
                        height: 20,
                      )
                    ]),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 1,
                        child: _buildTitleWidget()),
                  ),
                  hline(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.9,
                        width: MediaQuery.of(context).size.width * 1,
                        child: _buildContentWidget()),
                  )
                ],
              ),
            ),
          );
        },
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
}
