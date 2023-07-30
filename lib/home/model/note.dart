// ignore_for_file: strict_raw_type

import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class NoteModel {
  NoteModel(
    this.uuid,
    this.title,
    this.content,
    this.firestoreId,
    this.colorId,
    this.titleDeltaMap,
    this.contentDeltaMap,
    this.lastAccessedEpoch,
    this.isDeleted,
  );

  @HiveField(0)
  final String? firestoreId;

  @HiveField(1)
  final String uuid;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String content;

  @HiveField(4)
  final int colorId;

  @HiveField(5)
  final List titleDeltaMap;

  @HiveField(6)
  final List contentDeltaMap;

  @HiveField(7)
  int lastAccessedEpoch;

  @HiveField(8)
  bool isDeleted = false;

  Map<String, dynamic> toJson() => {
        noteUuid: uuid,
        noteTitle: title,
        noteContent: content,
        colorIdKey: colorId,
        titleData: titleDeltaMap,
        contentData: contentDeltaMap,
        lastAccessed: lastAccessedEpoch,
        isDeletedKey: isDeleted
      };

  static NoteModel fromJson(Map<String, dynamic> json) => NoteModel(
        json[noteUuid],
        json[noteTitle],
        json[noteContent],
        json[firebaseId],
        json[colorIdKey],
        json[titleData],
        json[contentData],
        json[lastAccessed],
        json[isDeletedKey],
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
const String isDeletedKey = 'isDeleted';
