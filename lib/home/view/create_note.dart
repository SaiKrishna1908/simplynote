import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplynote/app_color.dart';
import 'package:simplynote/constants.dart';
import 'package:simplynote/home/cubit/create_note_cubit.dart';
import 'package:simplynote/home/model/note.dart';

import 'package:simplynote/main.dart';
import 'package:tuple/tuple.dart';
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

  final int apiCallCronTimer = 1;

  Timer? timer;

  bool _showtoolBar = false;

  Widget _buildSimpleNoteToolbar() {
    return quill.QuillToolbar.basic(
      toolbarIconAlignment: WrapAlignment.spaceBetween,
      controller: _titleFocusNode.hasPrimaryFocus
          ? _titleController
          : _contentController,
      showFontFamily: false,
      showFontSize: false,
      showClearFormat: false,
      showInlineCode: false,
      showImageButton: false,
      showVideoButton: false,
      showHeaderStyle: false,
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
      showBackgroundColorButton: false,
      iconTheme: const quill.QuillIconTheme(
          borderRadius: 10,
          iconUnselectedColor: AppColor.appPrimaryColor,
          disabledIconColor: AppColor.appPrimaryColor,
          iconSelectedFillColor: AppColor.appPrimaryColor),
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
      placeholder: 'Title',
      customStyles: quill.DefaultStyles(
        lists: quill.DefaultListBlockStyle(
          const TextStyle(color: AppColor.appPrimaryColor),
          Tuple2.fromList([.2, .2]),
          Tuple2.fromList([.2, .2]),
          null,
          null,
        ),
        paragraph: quill.DefaultTextBlockStyle(
          const TextStyle(
            fontSize: 26,
            color: AppColor.appPrimaryColor,
            fontWeight: FontWeight.w400,
          ),
          Tuple2.fromList([.2, .2]),
          Tuple2.fromList([.2, .2]),
          null,
        ),
      ),
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
      customStyles: quill.DefaultStyles(
          paragraph: quill.DefaultTextBlockStyle(
        const TextStyle(
          fontSize: 18,
          color: AppColor.appPrimaryColor,
          fontWeight: FontWeight.w400,
        ),
        Tuple2.fromList([.2, .2]),
        Tuple2.fromList([.2, .2]),
        null,
      )),
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.titleDelta == null) {
      _titleController = quill.QuillController.basic();
    } else {
      final titleDocument = quill.Document.fromDelta(widget.titleDelta!);
      _titleController = quill.QuillController(
        document: titleDocument,
        selection: TextSelection.collapsed(
          offset: titleDocument.root.last.length - 1,
        ),
      );
    }

    _contentController = widget.contentDelta == null
        ? quill.QuillController.basic()
        : quill.QuillController(
            document: quill.Document.fromDelta(widget.contentDelta!),
            selection: const TextSelection.collapsed(offset: 0),
          );
    _documentUuid = widget.documentId ?? const Uuid().v4();
    _colorId = widget.colorId ??
        Random().nextInt(
          Constants.noteColors.length,
        );

    _titleFocusNode.addListener(
      () {
        setState(() {});
      },
    );

    _contentFocusNode.addListener(
      () {
        setState(() {});
      },
    );
    timer = Timer.periodic(
      Duration(seconds: apiCallCronTimer),
      (timer) async {
        final sp = await SharedPreferences.getInstance();
        if (!mounted) {
          return;
        }
        context.read<CreateNoteCubit>().createNote(
              NoteModel(
                _documentUuid,
                _titleController.document.toPlainText(),
                _contentController.document.toPlainText(),
                null,
                _colorId,
                _titleController.document.toDelta().toJson(),
                _contentController.document.toDelta().toJson(),
                DateTime.now().millisecondsSinceEpoch,
                false,
                sp.getString(Constants.uid),
              ),
              _documentUuid,
            );
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
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () {},
            textColor: AppColor.appAccentColor,
          ),
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

  final pageBodyLighthenFactor = 0.3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: AppColor.lighten(
        //     Constants.noteColors[_colorId], pageBodyLighthenFactor),
        title: Text(
          widget.noteFlow == NoteFlow.create ? 'Create Note' : 'Edit Note',
          style: const TextStyle(
            color: AppColor.appPrimaryColor,
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
