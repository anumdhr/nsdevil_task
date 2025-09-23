import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsdevil_project/config/sizedBox_extensions.dart';
import 'package:nsdevil_project/module/homepage/bloc/favourite_bloc.dart';
import 'package:nsdevil_project/module/homepage/bloc/favourite_event.dart';
import 'package:nsdevil_project/module/homepage/bloc/favourite_state.dart';
import 'package:nsdevil_project/module/homepage/models/post.dart';
import 'package:nsdevil_project/module/utils/const.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final post = ModalRoute.of(context)!.settings.arguments as Post;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          'Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            10.height,
            Text(
              expanded ? post.body : post.body.substring(0, 100),
              style: TextStyle(color: Colors.black),
            ),
            10.height,

            TextButton(
              child: Text(
                expanded ? "See Less" : "See More",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () => setState(() => expanded = !expanded),
            ),
            10.height,

            Text(
              post.tags.join(', '),
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
            10.height,

            Row(
              children: [
                const Icon(Icons.heat_pump_rounded, color: Colors.black),
                8.width,
                Text(
                  'Reactions: ${post.reactions}',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
            BlocBuilder<FavoritesBloc, FavoritesState>(
              builder: (context, state) {
                final isFav = state.favorites.any((p) => p.id == post.id);
                return Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        context.read<FavoritesBloc>().add(ToggleFavorite(post));
                      },
                    ),
                    Text(
                      "Click to add to favorites",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
