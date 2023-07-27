import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';

class ContentEditor extends StatefulWidget {
  const ContentEditor(
      {super.key, required this.quillController, required this.focusNode});

  final QuillController quillController;
  final FocusNode focusNode;

  @override
  State<ContentEditor> createState() => _ContentEditorState();
}

class _ContentEditorState extends State<ContentEditor> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return QuillEditor(
      controller: widget.quillController,
      focusNode: widget.focusNode,
      scrollController: scrollController,
      expands: true,
      padding: const EdgeInsets.all(10),
      autoFocus: false,
      readOnly: false,
      scrollable: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
