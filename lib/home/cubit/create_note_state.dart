part of 'create_note_cubit.dart';

class CreateNoteState {
  final NoteModel noteModel;

  CreateNoteState(this.noteModel);
}

class NoteModel {
  final String? firestoreId;
  final String uuid;
  final String title;
  final String content;
  final int colorId;

  NoteModel(
      this.uuid, this.title, this.content, this.firestoreId, this.colorId);

  Map<String, dynamic> toJson() => {
        noteUuid: uuid,
        noteTitle: title,
        noteContent: content,
        colorIdKey: colorId
      };

  static NoteModel fromJson(Map<String, dynamic> json) => NoteModel(
        json[noteUuid],
        json[noteTitle],
        json[noteContent],
        json[firebaseId],
        json[colorIdKey],
      );
}

const String noteUuid = 'uuid';
const String noteTitle = 'title';
const String noteContent = 'content';
const String firebaseId = 'firestoreId';
const String colorIdKey = 'colorId';
