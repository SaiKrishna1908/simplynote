import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplynote/home/model/note.dart';

import 'constants.dart';

abstract class StorageService {
  Future<void> createNote(NoteModel noteModel);

  Future<bool> deleteNote(String uuid);

  Future<NoteModel?> getNote(String uuid);

  Future<List<NoteModel>> fetchAllUserNotes({includeDeleted = false});

  static Future<void> sync(
      StorageService firebaseService, StorageService localStorage) async {
    try {
      // get files from cloud and store in localdatabase

      final firebaseNotes = await firebaseService.fetchAllUserNotes();

      for (final note in firebaseNotes) {
        final localNote = await localStorage.getNote(note.uuid);
        if (localNote == null) {
          await localStorage.createNote(note);
        }
      }

      final localNotes =
          await localStorage.fetchAllUserNotes(includeDeleted: true);

      for (final note in localNotes) {
        final firebaseNote = await firebaseService.getNote(note.uuid);
        if (firebaseNote == null) {
          firebaseService.createNote(note);
        } else if (note.lastAccessedEpoch > firebaseNote.lastAccessedEpoch) {
          firebaseService.createNote(note);
        }
      }
    } on Exception catch (e) {
      log(e.toString());
    }
  }
}

class FirebaseStorage extends StorageService {
  @override
  Future<void> createNote(NoteModel noteModel) async {
    assert(noteModel.uuid.isNotEmpty);

    final firebaseDocumentId = await getNote(noteModel.uuid);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      await createOrUpdateNotebook(
          noteModel.uuid, noteModel.toJson(), firebaseDocumentId?.firestoreId);
    });
  }

  Future<void> createOrUpdateNotebook(String noteBookByUuid,
      Map<String, dynamic> json, String? firestoreId) async {
    final userNotesCollection = FirebaseFirestore.instance
        .collection(GetIt.I<SharedPreferences>().getString(Constants.uid)!);
    if (firestoreId != null) {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await userNotesCollection.doc(firestoreId).update(json);
      });
    } else {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await userNotesCollection.add(json);
      });
    }
  }

  @override
  Future<bool> deleteNote(String uuid) async {
    final userNotesCollection = FirebaseFirestore.instance
        .collection(GetIt.I<SharedPreferences>().getString(Constants.uid)!);

    try {
      final doc = await getNote(uuid);
      if (doc != null) {
        doc.isDeleted = true;
        userNotesCollection.doc(doc.firestoreId).update(doc.toJson());
        return true;
      }
    } on FirebaseException {
      debugPrint('Error deleting document');
    } on Exception {
      debugPrint('Something went wrong');
    }
    return false;
  }

  @override
  Future<NoteModel?> getNote(String uuid) async {
    final userNotesCollection = FirebaseFirestore.instance
        .collection(GetIt.I<SharedPreferences>().getString(Constants.uid)!);
    final querySnapsnot =
        await userNotesCollection.where(noteUuid, isEqualTo: uuid).get();

    if (querySnapsnot.docs.isNotEmpty) {
      return NoteModel.fromJson(querySnapsnot.docs.first.data()
        ..putIfAbsent(firebaseId, () => querySnapsnot.docs.first.id));
    }

    return null;
  }

  @override
  Future<List<NoteModel>> fetchAllUserNotes({includeDeleted = false}) async {
    final userNotesCollection = FirebaseFirestore.instance
        .collection(GetIt.I<SharedPreferences>().getString(Constants.uid)!);
    final userCollection = await userNotesCollection.get();

    final userDocs = userCollection.docs
        .map(
          (doc) => NoteModel.fromJson(
            doc.data()..putIfAbsent(firebaseId, () => doc.id),
          ),
        )
        .toList();

    return userDocs;
  }
}

class HiveStorage extends StorageService {
  @override
  Future<void> createNote(NoteModel noteModel) async {
    final notesBox = GetIt.I<Box<NoteModel>>();

    await notesBox.put(noteModel.uuid, noteModel);
  }

  @override
  Future<bool> deleteNote(String uuid) async {
    final notesBox = GetIt.I<Box<NoteModel>>();
    final noteToDelete = await getNote(uuid);

    if (noteToDelete != null) {
      noteToDelete.isDeleted = true;
      noteToDelete.lastAccessedEpoch = DateTime.now().millisecondsSinceEpoch;
      await notesBox.put(uuid, noteToDelete);
    }

    return true;
  }

  @override
  Future<List<NoteModel>> fetchAllUserNotes({includeDeleted = false}) async {
    final currentUserId = GetIt.I<SharedPreferences>().getString(Constants.uid);
    final notesBox = GetIt.I<Box<NoteModel>>();

    if (includeDeleted) {
      return notesBox.values.toList();
    }
    return notesBox.values
        .where(
          (element) =>
              !element.isDeleted &&
              element.userId != null &&
              element.userId == currentUserId,
        )
        .toList();
  }

  @override
  Future<NoteModel?> getNote(String uuid) async {
    final notesBox = GetIt.I<Box<NoteModel>>();
    return notesBox.values.toList().firstWhereOrNull(
          (element) => element.uuid == uuid,
        );
  }
}
