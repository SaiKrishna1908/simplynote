import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplynote/constants.dart';

part 'create_note_state.dart';

class CreateNoteCubit extends Cubit<CreateNoteState> {
  CreateNoteCubit()
      : super(
          CreateNoteState(
            NoteModel('', Constants.emptyString, Constants.emptyString),
          ),
        );

  final userNotesCollection = FirebaseFirestore.instance
      .collection(GetIt.I<SharedPreferences>().getString(Constants.uid)!);
  Future<void> createNote(NoteModel noteModel, String uuid) async {
    if (uuid.isEmpty) {
      return;
    }
    final queryForNote = await queryForExistingNote(uuid);
    if (queryForNote.docs.isEmpty) {
      userNotesCollection.add(noteModel.toJson());
    } else {
      userNotesCollection
          .doc(queryForNote.docs.first.id)
          .update(noteModel.toJson());
    }
  }

  Future<QuerySnapshot> queryForExistingNote(String docUuid) async {
    return await userNotesCollection.where(noteUuid, isEqualTo: docUuid).get();
  }
}
