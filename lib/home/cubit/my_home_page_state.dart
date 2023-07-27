part of 'my_home_page_cubit.dart';

abstract class MyHomePageState {}

class MyHomePageInitial extends MyHomePageState {}

class MyHomePageLoading extends MyHomePageState {}

class MyHomePageLoaded extends MyHomePageState {
  MyHomePageLoaded(this.userNotes, this.isSearchActive, this.searchNotes);
  final List<NoteModel> userNotes;
  final bool isSearchActive;
  final List<NoteModel> searchNotes;
}

class MyHomePageError extends MyHomePageState {
  MyHomePageError(this.message);
  final String message;
}
