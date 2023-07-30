import 'dart:ui';

class Constants {
  static const String uid = 'uid';
  static const String emptyString = '';

  static const noteColors = <Color>[
    Color(0xffEF5350),
    Color(0xffF06292),
    Color(0xffAB47BC),
    Color(0xff303F9F),
    Color(0xff00796B),
    Color(0xffFBC02D),
    Color(0xffE65100),
    Color(0xff455A64),
    Color(0xff0097A7),
    Color(0xff5D4037),
  ];

  static const enableMarkDown = false;
}

enum StorageOptions {
  firebaseDatabase,
  hiveDatabase,
}

enum NoteFlow { create, edit }
