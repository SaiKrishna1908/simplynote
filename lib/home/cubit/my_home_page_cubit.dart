import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplynote/constants.dart';
import 'package:simplynote/home/cubit/create_note_cubit.dart';
import 'package:simplynote/storage_service.dart';

part 'my_home_page_state.dart';

class MyHomePageCubit extends Cubit<MyHomePageState> {
  MyHomePageCubit() : super(MyHomePageInitial());

  final userNotesCollection = FirebaseFirestore.instance
      .collection(GetIt.I<SharedPreferences>().getString(Constants.uid)!);

  Future<void> getUserNotes() async {
    emit(MyHomePageLoading());

    try {
      final storageService = FirebaseStorage();
      final userNotes = await storageService.fetchAllUserNotes();
      emit(MyHomePageLoaded(userNotes, false, userNotes));
    } on FirebaseException catch (firebaseException) {
      emit(MyHomePageError(firebaseException.message!));
      return;
    }
  }

  Future<void> toggleSearch(bool search, String searchText) async {
    if (state is MyHomePageLoaded) {
      final ls = state as MyHomePageLoaded;
      final searchNotes = <NoteModel>[];
      if (search == true) {
        searchNotes.addAll(ls.userNotes.where((element) =>
            element.title.toLowerCase().contains(searchText.toLowerCase())));
      }
      emit(MyHomePageLoaded(ls.userNotes, search, searchNotes));
    }
  }
}
