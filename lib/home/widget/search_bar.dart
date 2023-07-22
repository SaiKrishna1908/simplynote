import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplynote/app_color.dart';
import 'package:simplynote/home/cubit/my_home_page_cubit.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key, required this.searchCallback});

  final Function(String) searchCallback;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _textEditingController;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _focusNode.addListener(() {
      _focusListiner();
    });
    _textEditingController.addListener(() {
      _textListener();
    });
  }

  Widget _hgap() {
    return const SizedBox(
      width: 20,
    );
  }

  void _textListener() {
    final cubit = context.read<MyHomePageCubit>();
    if (_textEditingController.text.isEmpty) {
      cubit.toggleSearch(false, _textEditingController.text);
    } else {
      cubit.toggleSearch(true, _textEditingController.text);
    }
  }

  void _focusListiner() {
    final cubit = context.read<MyHomePageCubit>();
    if (_focusNode.hasFocus) {
      if (cubit.state is MyHomePageLoaded) {
        cubit.toggleSearch(true, _textEditingController.text);
      }
    } else {
      cubit.toggleSearch(false, _textEditingController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    const searchBarHeight = 50.0;
    const searchBarBorderRadius = 18.0;
    return BlocBuilder<MyHomePageCubit, MyHomePageState>(
      builder: (context, state) {
        if (state is MyHomePageLoaded) {
          return Container(
            height: searchBarHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                searchBarBorderRadius,
              ),
              border: Border.all(
                color: theme.primaryColor,
                width: 0.5,
              ),
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                const Icon(
                  Icons.search_rounded,
                  size: 40,
                ),
                _hgap(),
                SizedBox(
                  width: size.width * 0.6,
                  height: searchBarHeight * 0.9,
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _textEditingController,
                    onEditingComplete: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    decoration: InputDecoration(
                      hintText: 'Search Notes',
                      hintStyle: TextStyle(
                        color: theme.hintColor,
                        fontSize: 18,
                      ),
                      border: InputBorder.none,
                    ),
                    cursorColor: AppColor.appPrimaryColor,
                    style: const TextStyle(
                      color: AppColor.appSecondaryColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                    onChanged: (value) => widget.searchCallback(value),
                  ),
                ),
                _hgap(),
                if (state.isSearchActive)
                  IconButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      _textEditingController.clear();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColor.appPrimaryColor,
                    ),
                  )
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
