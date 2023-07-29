part of 'create_note_cubit.dart';

class CreateNoteState {
  CreateNoteState(this.noteModel);
  final NoteModel noteModel;
}

class NoteModel {
  NoteModel(
    this.uuid,
    this.title,
    this.content,
    this.firestoreId,
    this.colorId,
    this.titleDelta,
    this.contentDelta,
  ) : lastAccessedEpoch = DateTime.now().millisecondsSinceEpoch;
  final String? firestoreId;
  final String uuid;
  final String title;
  final String content;
  final int colorId;
  final Delta titleDelta;
  final Delta contentDelta;
  final int lastAccessedEpoch;

  Map<String, dynamic> toJson() => {
        noteUuid: uuid,
        noteTitle: title,
        noteContent: content,
        colorIdKey: colorId,
        titleData: titleDelta.toJson(),
        contentData: contentDelta.toJson(),
        lastAccessed: lastAccessedEpoch
      };

  static NoteModel fromJson(Map<String, dynamic> json) => NoteModel(
        json[noteUuid],
        json[noteTitle],
        json[noteContent],
        json[firebaseId],
        json[colorIdKey],
        Delta.fromJson(json[titleData]),
        Delta.fromJson(json[contentData]),
      );
}

const String noteUuid = 'uuid';
const String noteTitle = 'title';
const String noteContent = 'content';
const String firebaseId = 'firestoreId';
const String colorIdKey = 'colorId';
const String titleData = 'titleDelta';
const String contentData = 'contentDelta';
const String lastAccessed = 'lastAccessedEpoch';
