import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplynote/constants.dart';
import 'package:simplynote/home/view/cubit/create_note_cubit.dart';

part 'my_home_page_state.dart';

class MyHomePageCubit extends Cubit<MyHomePageState> {
  MyHomePageCubit() : super(MyHomePageInitial());

  final userNotesCollection = FirebaseFirestore.instance
      .collection(GetIt.I<SharedPreferences>().getString(Constants.uid)!);

  Future<void> getUserNotes() async {
    emit(MyHomePageLoading());

    try {
      final collectionDocs = await userNotesCollection.get();
      final userNotes = collectionDocs.docs.map((doc) {
        final uuid = doc.data()[noteUuid];
        final title = doc.data()[noteTitle];
        final content = doc.data()[noteContent];

        return NoteModel(uuid, title, content);
      }).toList();

      emit(MyHomePageLoaded(userNotes));
    } on FirebaseException catch (firebaseException) {
      emit(MyHomePageError(firebaseException.message!));
      return;
    }
  }
}
