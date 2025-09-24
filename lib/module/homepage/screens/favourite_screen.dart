import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsdevil_project/module/homepage/bloc/favourite/favourite_bloc.dart';
import 'package:nsdevil_project/module/homepage/widgets/post_tile.dart';

import '../bloc/favourite/favourite_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state.favorites.isEmpty) {
            return const Center(child: Text("No favorites yet"));
          }
          return ListView(
            children: state.favorites.map((p) => PostTile(post: p)).toList(),
          );
        },
      ),
    );
  }
}
