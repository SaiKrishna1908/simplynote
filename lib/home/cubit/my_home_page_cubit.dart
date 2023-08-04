import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplynote/constants.dart';
import 'package:simplynote/home/model/note.dart';
import 'package:simplynote/storage_service.dart';

part 'my_home_page_state.dart';

class MyHomePageCubit extends Cubit<MyHomePageState> {
  MyHomePageCubit()
      : firebaseStorage = GetIt.I<StorageService>(
            instanceName: StorageOptions.firebaseDatabase.name),
        hiveStorage = GetIt.I<StorageService>(
            instanceName: StorageOptions.hiveDatabase.name),
        super(MyHomePageInitial());

  final userNotesCollection = FirebaseFirestore.instance
      .collection(GetIt.I<SharedPreferences>().getString(Constants.uid)!);

  final StorageService firebaseStorage;
  final StorageService hiveStorage;

  Future<void> getUserNotes() async {
    emit(MyHomePageLoading());

    try {
      final userNotes = await hiveStorage.fetchAllUserNotes();
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

  Future<void> syncNotes() async {
    if (state is MyHomePageLoaded) {
      await StorageService.sync(
        firebaseStorage,
        hiveStorage,
      );

      final ls = state as MyHomePageLoaded;

      emit(
        MyHomePageLoaded(ls.userNotes, ls.isSearchActive, ls.searchNotes),
      );
    }
  }
}
