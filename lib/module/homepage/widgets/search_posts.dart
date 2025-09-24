import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsdevil_project/module/homepage/bloc/post/post_bloc.dart';

import '../bloc/post/post_event.dart';

class SearchPost extends StatelessWidget {
  const SearchPost({super.key, required TextEditingController searchController})
    : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        context.read<PostBloc>().add(SearchPostsEvent(value));
      },
      onTapOutside: (event) {
        FocusScope.of(context)!.unfocus();
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        hintText: 'Search posts',
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        suffixIcon: InkWell(
          onTap: () {
            if (_searchController.text.trim() != "") {
              _searchController.clear();
              context.read<PostBloc>().add(LoadPostsEvent());
            }
          },
          child: const Icon(Icons.clear, color: Colors.grey),
        ),
      ),
    );
  }
}
