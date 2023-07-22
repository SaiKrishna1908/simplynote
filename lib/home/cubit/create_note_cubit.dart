import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplynote/constants.dart';
import 'package:simplynote/storage_service.dart';

part 'create_note_state.dart';

class CreateNoteCubit extends Cubit<CreateNoteState> {
  CreateNoteCubit()
      : super(
          CreateNoteState(
            NoteModel(Constants.emptyString, Constants.emptyString,
                Constants.emptyString, null, 1),
          ),
        );

  Future<void> createNote(NoteModel noteModel, String uuid) async {
    final StorageService storageService = FirebaseStorage();

    await storageService.createNote(noteModel);
  }
}
