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

  NoteModel(this.uuid, this.title, this.content, this.firestoreId);

  Map<String, dynamic> toJson() =>
      {noteUuid: uuid, noteTitle: title, noteContent: content};

  static NoteModel fromJson(Map<String, dynamic> json) => NoteModel(
      json[noteUuid], json[noteTitle], json[noteContent], json[firebaseId]);
}

const String noteUuid = 'uuid';
const String noteTitle = 'title';
const String noteContent = 'content';
const String firebaseId = 'firestoreId';
