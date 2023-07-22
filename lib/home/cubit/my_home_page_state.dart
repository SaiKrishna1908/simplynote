part of 'my_home_page_cubit.dart';

@immutable
abstract class MyHomePageState {}

class MyHomePageInitial extends MyHomePageState {}

class MyHomePageLoading extends MyHomePageState {}

class MyHomePageLoaded extends MyHomePageState {
  final List<NoteModel> userNotes;
  final bool isSearchActive;
  final List<NoteModel> searchNotes;

  MyHomePageLoaded(this.userNotes, this.isSearchActive, this.searchNotes);
}

class MyHomePageError extends MyHomePageState {
  final String message;

  MyHomePageError(this.message);
}
