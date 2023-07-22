import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplynote/app_color.dart';
import 'package:simplynote/home/view/cubit/create_note_cubit.dart';
import 'package:simplynote/home/widget/search_bar.dart';
import 'package:simplynote/main.dart';

import 'cubit/my_home_page_cubit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget _gap() {
    return const SizedBox(
      height: 30,
    );
  }

  Widget titleWidget(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColor.appPrimaryColor,
        fontSize: 40,
        letterSpacing: 0,
        wordSpacing: 0,
        fontStyle: FontStyle.italic,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget notesGridView(List<NoteModel> notes) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (context, index) => noteWidget(notes[index]),
      itemCount: notes.length,
    );
  }

  Widget noteWidget(NoteModel noteModel) {
    return SizedBox(
      height: 80,
      width: 80,
      child: Card(
        elevation: 15,
        borderOnForeground: true,
        shadowColor: AppColor.darken(AppColor.appPrimaryColor, 0.9),
        color: AppColor.appPrimaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                noteModel.title,
                style: const TextStyle(
                  color: AppColor.appAccentColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              _gap(),
              Expanded(
                child: Text(
                  noteModel.content,
                  maxLines: 100,
                  style: const TextStyle(
                    color: AppColor.appAccentColor,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    wordSpacing: 0.5,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: AppColor.appAccentColor,
          child: IconButton(
            icon: const Icon(
              Icons.add,
              color: AppColor.appSecondaryColor,
              size: 30,
            ),
            onPressed: () => goRouter.push('/create'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(),
      body: BlocBuilder<MyHomePageCubit, MyHomePageState>(
        builder: (context, state) {
          if (state is MyHomePageInitial) {
            context.read<MyHomePageCubit>().getUserNotes();
          } else if (state is MyHomePageLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.appPrimaryColor,
              ),
            );
          } else if (state is MyHomePageLoaded) {
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SearchBar(
                        searchCallback: (s) => state.userNotes
                            .where((element) => element.title.contains(s)),
                      ),
                      _gap(),
                      titleWidget('Your Notes'),
                      _gap(),
                      notesGridView(state.isSearchActive
                          ? state.searchNotes
                          : state.userNotes),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is MyHomePageError) {}
          return Container();
        },
      ),
    );
  }
}
