import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:simplynote/app_color.dart';
import 'package:simplynote/auth/auth_service.dart';
import 'package:simplynote/constants.dart';
import 'package:simplynote/home/cubit/create_note_cubit.dart';
import 'package:simplynote/home/cubit/my_home_page_cubit.dart';
import 'package:simplynote/home/widget/drawer.dart';
import 'package:simplynote/home/widget/search_bar.dart';
import 'package:simplynote/main.dart';

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
    final cardColor = Constants.noteColors[noteModel.colorId];
    return SizedBox(
      height: 80,
      width: 80,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: AppColor.darken(
                  cardColor,
                  0.8,
                ),
                blurRadius: 1,
                spreadRadius: 0.5,
                blurStyle: BlurStyle.outer),
          ],
        ),
        // elevation: 15,
        // borderOnForeground: true,
        // shadowColor: AppColor.darken(cardColor, 0.9),

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
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
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
                    fontWeight: FontWeight.w500,
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
          backgroundColor: AppColor.appSecondaryColor,
          child: IconButton(
            icon: const Icon(
              Icons.add,
              color: AppColor.appAccentColor,
              size: 30,
            ),
            onPressed: () => goRouter.push('/create').then((value) async {
              await context.read<MyHomePageCubit>().getUserNotes();
            }),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => Wrap(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.logout),
                            title: const Text('Logout'),
                            onTap: () async {
                              await GetIt.I<AuthService>().signOut();
                              goRouter.go('/');
                            },
                          )
                        ],
                      )),
              icon: const Icon(Icons.more_vert))
        ],
      ),
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
            return SingleChildScrollView(
              child: RefreshIndicator(
                onRefresh: () => context.read<MyHomePageCubit>().getUserNotes(),
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
                      titleWidget('My Notes'),
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
