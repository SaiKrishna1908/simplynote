import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplynote/home/cubit/create_note_cubit.dart';

import 'constants.dart';

abstract class StorageService {
  Future<void> createNote(NoteModel noteModel);

  Future<bool> deleteNote(String uuid);

  Future<NoteModel?> getNote(String uuid);

  Future<List<NoteModel>> fetchAllUserNotes();
}

class FirebaseStorage extends StorageService {
  @override
  Future<void> createNote(NoteModel noteModel) async {
    final userNotesCollection = FirebaseFirestore.instance
        .collection(GetIt.I<SharedPreferences>().getString(Constants.uid)!);
    assert(noteModel.uuid.isNotEmpty);

    final noteBookByUuid = await getNote(noteModel.uuid);

    if (noteBookByUuid != null) {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await userNotesCollection
            .doc(noteBookByUuid.firestoreId)
            .update(noteModel.toJson());
      });
    } else {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await userNotesCollection.add(
          noteModel.toJson(),
        );
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
        userNotesCollection.doc(doc.firestoreId).delete();
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
  Future<List<NoteModel>> fetchAllUserNotes() async {
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
