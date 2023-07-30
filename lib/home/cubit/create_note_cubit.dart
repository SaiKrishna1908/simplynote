import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:simplynote/constants.dart';
import 'package:simplynote/home/model/note.dart';
import 'package:simplynote/storage_service.dart';

part 'create_note_state.dart';

class CreateNoteCubit extends Cubit<CreateNoteState> {
  CreateNoteCubit(NoteModel notemodel)
      : super(
          CreateNoteState(notemodel),
        );

  Future<void> createNote(NoteModel noteModel, String uuid) async {
    await GetIt.I<StorageService>(
            instanceName: StorageOptions.hiveDatabase.name)
        .createNote(noteModel);
  }

  Future<bool> deleteNote(String uuid) async {
    return GetIt.I<StorageService>(
            instanceName: StorageOptions.hiveDatabase.name)
        .deleteNote(uuid);
  }
}
