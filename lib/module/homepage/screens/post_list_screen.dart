import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsdevil_project/config/sizedBox_extensions.dart';
import 'package:nsdevil_project/module/homepage/bloc/favourite_bloc.dart';
import 'package:nsdevil_project/module/homepage/bloc/favourite_event.dart';
import 'package:nsdevil_project/module/homepage/bloc/post_bloc.dart';
import 'package:nsdevil_project/module/homepage/bloc/post_event.dart';
import 'package:nsdevil_project/module/homepage/bloc/post_state.dart';
import 'package:nsdevil_project/module/homepage/bloc/theme_cubit.dart';
import 'package:nsdevil_project/module/homepage/widgets/post_tile.dart';
import 'package:nsdevil_project/module/homepage/widgets/search_posts.dart';
import 'package:nsdevil_project/module/utils/const.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Load initial posts
    context.read<PostBloc>().add(LoadPostsEvent());

    // Pagination listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        context.read<PostBloc>().add(LoadPostsEvent(loadMore: true));
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    context.read<PostBloc>().add(LoadPostsEvent());
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'All Posts',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              context.read<FavoritesBloc>().add(LoadFavorites());
              Navigator.pushNamed(context, "favoriteScreen");
            },
          ),
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () => context.read<ThemeCubit>().toggle(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            SearchPost(searchController: _searchController),
            5.height,

            BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                if (state is PostLoading && state is! PostLoadingMore) {
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state is PostLoaded || state is PostLoadingMore) {
                  final posts = state is PostLoaded
                      ? state.posts
                      : (state as PostLoadingMore).oldPosts;

                  final hasMore = state is PostLoaded ? state.hasMore : true;

                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView.separated(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        separatorBuilder: (_, __) => 5.height,
                        itemCount: posts.length + (hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < posts.length) {
                            return PostTile(post: posts[index]);
                          } else {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                        },
                      ),
                    ),
                  );
                }

                if (state is PostEmpty) {
                  return const Expanded(
                    child: Center(child: Text("No posts found")),
                  );
                }

                if (state is PostError) {
                  return Expanded(
                    child: Center(child: Text("Error: ${state.message}")),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
