part of 'my_home_page_cubit.dart';

@immutable
abstract class MyHomePageState {}

class MyHomePageInitial extends MyHomePageState {}

class MyHomePageLoading extends MyHomePageState {}

class MyHomePageLoaded extends MyHomePageState {
  final List<NoteModel> userNotes;

  MyHomePageLoaded(this.userNotes);
}

class MyHomePageError extends MyHomePageState {
  final String message;

  MyHomePageError(this.message);
}
