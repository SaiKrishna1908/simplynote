import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplynote/home/cubit/create_note_cubit.dart';

import 'constants.dart';

abstract class StorageService {
  final userNotesCollection = FirebaseFirestore.instance
      .collection(GetIt.I<SharedPreferences>().getString(Constants.uid)!);
  Future<void> createNote(NoteModel noteModel);

  Future<void> deleteNote(String uuid);

  Future<void> editNote(String uuid);

  Future<NoteModel?> getNote(String uuid);
}

class FirebaseStorage extends StorageService {
  @override
  Future<void> createNote(NoteModel noteModel) async {
    assert(noteModel.uuid.isNotEmpty);

    final noteBookByUuid = await getNote(noteModel.uuid);

    if (noteBookByUuid != null) {
      userNotesCollection
          .doc(noteBookByUuid.firestoreId)
          .update(noteModel.toJson());
    } else {
      userNotesCollection.add(noteModel.toJson());
    }
  }

  @override
  Future<void> deleteNote(String uuid) {
    // TODO: implement deleteNote
    throw UnimplementedError();
  }

  @override
  Future<void> editNote(String uuid) {
    // TODO: implement editNote
    throw UnimplementedError();
  }

  @override
  Future<NoteModel?> getNote(String uuid) async {
    final querySnapsnot =
        await userNotesCollection.where(noteUuid, isEqualTo: uuid).get();

    if (querySnapsnot.docs.isNotEmpty) {
      return NoteModel.fromJson(querySnapsnot.docs.first.data()
        ..putIfAbsent(firebaseId, () => querySnapsnot.docs.first.id));
    }

    return null;
  }
}
