import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsdevil_project/module/utils/route.dart';

import '../../services/navigation_services.dart';
import '../../utils/nav_locator.dart';
import '../bloc/connectivity_cubit/connectivity_cubit.dart';
import '../bloc/favourite/favourite_bloc.dart';
import '../bloc/favourite/favourite_state.dart';
import '../bloc/post/post_bloc.dart';
import '../bloc/post/post_event.dart';
import '../bloc/post/post_state.dart';
import '../bloc/theme/theme_cubit.dart';
import '../widgets/connectivity_banner.dart';
import '../widgets/post_tile.dart';
import '../widgets/search_posts.dart';

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
    context.read<PostBloc>().add(LoadPostsEvent());
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Postly'),
        centerTitle: true,
        actions: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              final favCount = state.favorites.length;

              return Badge(
                label: Text('$favCount'),
                isLabelVisible: favCount > 0,
                offset: const Offset(-4, 4),
                child: IconButton(
                  icon: Icon(Icons.favorite, color: theme.colorScheme.primary),
                  onPressed: () {
                    locator<NavigationService>().navigateTo(
                      AppRoutes.favoriteScreen,
                    );
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () => context.read<ThemeCubit>().toggle(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<ConnectivityCubit, ConnectivityState>(
            builder: (context, state) {
              if (state is ConnectivityDisconnected) {
                return const ConnectivityBanner();
              }
              return const SizedBox.shrink();
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SearchPost(searchController: _searchController),
                  const SizedBox(height: 16),
                  Expanded(
                    child: BlocBuilder<PostBloc, PostState>(
                      builder: (context, state) {
                        if (state is PostLoading && state is! PostLoadingMore) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (state is PostLoaded || state is PostLoadingMore) {
                          final posts = state is PostLoaded
                              ? state.posts
                              : (state as PostLoadingMore).oldPosts;
                          final hasMore = state is PostLoaded
                              ? state.hasMore
                              : true;

                          return _buildListView(posts, hasMore);
                        }
                        if (state is PostEmpty) {
                          return const Center(child: Text("No posts found"));
                        }
                        if (state is PostError) {
                          return Center(child: Text("Error: ${state.message}"));
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<dynamic> posts, bool hasMore) {
    return RefreshIndicator(
      key: const ValueKey('postListView'),
      onRefresh: _onRefresh,
      child: ListView.separated(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (_, __) => const SizedBox(height: 16),
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
    );
  }
}
