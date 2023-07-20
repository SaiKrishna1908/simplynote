import 'package:flutter/material.dart';
import 'package:simplynote/app_color.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key, required this.searchCallback});

  final Function(String) searchCallback;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  Widget _hgap() {
    return const SizedBox(
      width: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    const searchBarHeight = 50.0;
    const searchBarBorderRadius = 18.0;
    return Container(
      height: searchBarHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          searchBarBorderRadius,
        ),
        border: Border.all(
          color: theme.primaryColor,
          width: 2,
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
            width: size.width * 0.9,
            height: searchBarHeight * 0.9,
            child: TextField(
              maxLines: 100,
              decoration: InputDecoration(
                hintText: 'Search Notes',
                hintStyle: TextStyle(
                  color: theme.hintColor,
                  fontSize: 18,
                ),
                border: InputBorder.none,
              ),
              cursorColor: theme.primaryColor,
              style: const TextStyle(
                color: AppColor.appSecondaryColor,
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
              onChanged: (value) => widget.searchCallback(value),
            ),
          )
        ],
      ),
    );
  }
}
