import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_it/get_it.dart';
import 'package:simplynote/app_color.dart';
import 'package:simplynote/auth/auth_service.dart';
import 'package:simplynote/constants.dart';
import 'package:simplynote/home/cubit/my_home_page_cubit.dart';
import 'package:simplynote/home/model/note.dart';
import 'package:simplynote/home/widget/search_bar.dart';
import 'package:simplynote/main.dart';
import 'package:simplynote/storage_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool searchActive = false;
  Widget _gap() {
    return const SizedBox(
      height: 30,
    );
  }

  Widget titleWidget(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontWeight: FontWeight.w400,
          color: AppColor.appPrimaryColor,
          fontSize: 30,
          letterSpacing: 0,
          wordSpacing: 0,
          fontFamily: 'Brandon'),
      textAlign: TextAlign.center,
    );
  }

  double getHeightForText(String content) {
    /*
      min height = 80
      max height = 150
    */
    // final textPainter = TextPainter(text: TextSpan(text: content));
    // debugPrint(textPainter.height.toString());
    final textLines = '\n'.allMatches(content).length + 1;

    if (textLines == 0) {
      return 1;
    }

    const maxLines = 10;
    const minLines = 1;

    const minHeight = 1;
    const maxHeight = 2;

    return minHeight +
        (maxHeight - minHeight) /
            (maxLines - minLines) *
            (min(textLines, maxLines) - minLines);
  }

  Widget notesStaggeredView(List<NoteModel> notes) {
    notes.sort(
      (a, b) => b.lastAccessedEpoch - a.lastAccessedEpoch,
    );
    return StaggeredGrid.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        ...List.generate(
          notes.length,
          (index) => StaggeredGridTile.count(
            // height
            mainAxisCellCount: getHeightForText(
              notes[index].content,
            ),
            crossAxisCellCount: 1,
            child: noteWidget(
              notes[index],
            ),
          ),
        )
      ],
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
    final cardColor = Constants.noteColors[noteModel.colorId].withOpacity(0.8);
    return InkWell(
      onTap: () => goRouter
          .push('/edit/${noteModel.uuid}', extra: noteModel)
          .then((value) => context.read<MyHomePageCubit>().getUserNotes()),
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 120,
          minHeight: 80,
          minWidth: 80,
          maxWidth: 80,
        ),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 0.3),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                noteModel.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              _gap(),
              Expanded(
                child: Text(
                  noteModel.content,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    // overflow: TextOverflow.fade,
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

  Future<void> signOut() async {
    await GetIt.I<AuthService>().signOut();
    goRouter.go('/');
  }

  Future<void> sync() async {
    await StorageService.sync(
      GetIt.I<StorageService>(
          instanceName: StorageOptions.firebaseDatabase.name),
      GetIt.I<StorageService>(
        instanceName: StorageOptions.hiveDatabase.name,
      ),
    );
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  Future<void> showBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            style: ListTileStyle.list,
            iconColor: AppColor.appSecondaryColor,
            dense: false,
            leading: const Icon(Icons.sync),
            title: const Text(
              'Sync',
              style: TextStyle(
                color: AppColor.appSecondaryColor,
                fontSize: 18,
              ),
            ),
            onTap: () => sync(),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: ListTile(
              style: ListTileStyle.list,
              iconColor: AppColor.appSecondaryColor,
              dense: false,
              leading: const Icon(Icons.logout),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: AppColor.appSecondaryColor,
                  fontSize: 18,
                ),
              ),
              onTap: () => signOut(),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
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
            onPressed: () => goRouter.push('/create').then(
              (value) async {
                await context.read<MyHomePageCubit>().getUserNotes();
              },
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => setState(
              () {
                searchActive = !searchActive;
              },
            ),
            icon: Icon(
              searchActive ? Icons.search_off : Icons.search,
            ),
          ),
          IconButton(
            onPressed: () => showBottomSheet(),
            icon: const Icon(Icons.more_vert),
          ),
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
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<MyHomePageCubit>().getUserNotes();
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleWidget('Notes'),
                      _gap(),
                      if (searchActive)
                        Center(
                          child: SearchBar(
                            searchCallback: (s) => state.userNotes
                                .where((element) => element.title.contains(s)),
                          ),
                        ),
                      _gap(),
                      notesStaggeredView(
                        state.isSearchActive
                            ? state.searchNotes
                            : state.userNotes,
                      ),
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
