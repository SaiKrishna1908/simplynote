part of 'create_note_cubit.dart';

class CreateNoteState {
  final NoteModel noteModel;

  CreateNoteState(this.noteModel);
}

class NoteModel {
  final String uuid;
  final String title;
  final String content;

  NoteModel(this.uuid, this.title, this.content);

  Map<String, dynamic> toJson() =>
      {noteUuid: uuid, noteTitle: title, noteContent: content};
}

const String noteUuid = 'uuid';
const String noteTitle = 'title';
const String noteContent = 'content';
