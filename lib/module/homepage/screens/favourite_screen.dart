// lib/views/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsdevil_project/module/homepage/bloc/favourite_bloc.dart';
import 'package:nsdevil_project/module/homepage/bloc/favourite_state.dart';
import 'package:nsdevil_project/module/homepage/widgets/post_tile.dart';

class FavoritesScreen extends StatelessWidget {
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
