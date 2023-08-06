// ignore_for_file: strict_raw_type

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:simplynote/app_color.dart';
import 'package:tuple/tuple.dart';

class ReadOnlyQuillEditor extends StatelessWidget {
  const ReadOnlyQuillEditor({
    super.key,
    required this.delta,
  });

  final List delta;

  Widget getCard() {
    return QuillEditor(
      onTapDown: (details, p1) {
        return false;
      },
      autoFocus: false,
      controller: QuillController(
          document: Document.fromJson(delta),
          selection: const TextSelection.collapsed(offset: 0)),
      expands: false,
      focusNode: FocusNode(),
      scrollController: ScrollController(),
      padding: EdgeInsets.zero,
      readOnly: true,
      scrollable: false,
      placeholder: 'Your Notes',
      showCursor: false,
      customStyles: DefaultStyles(
        paragraph: DefaultTextBlockStyle(
          const TextStyle(
            fontSize: 18,
            color: AppColor.appPrimaryColor,
            fontWeight: FontWeight.w400,
          ),
          Tuple2.fromList([1.0, 1.0]),
          Tuple2.fromList([1.0, 1.0]),
          null,
        ),
        leading: DefaultTextBlockStyle(
          const TextStyle(color: AppColor.appPrimaryColor),
          Tuple2.fromList(
            [1.0, 1.0],
          ),
          Tuple2.fromList(
            [1.0, 1.0],
          ),
          null,
        ),
        lists: DefaultListBlockStyle(
          const TextStyle(color: AppColor.appPrimaryColor),
          Tuple2.fromList([1.0, 1.0]),
          Tuple2.fromList([1.0, 1.0]),
          BoxDecoration(
            color: AppColor.appPrimaryColor,
            border: Border.all(color: AppColor.appPrimaryColor),
          ),
          null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return getCard();

    // return getCard();
  }
}
