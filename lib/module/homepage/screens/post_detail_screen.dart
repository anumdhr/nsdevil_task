import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsdevil_project/module/homepage/bloc/favourite/favourite_bloc.dart';
import 'package:nsdevil_project/module/homepage/bloc/post/post_bloc.dart';
import 'package:nsdevil_project/module/homepage/models/post.dart';
import 'package:nsdevil_project/module/homepage/widgets/post_tile.dart';

import '../bloc/favourite/favourite_event.dart';
import '../bloc/favourite/favourite_state.dart';
import '../bloc/post/post_state.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key, required this.post});
  final Post post;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Details'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.post.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              InkWell(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: AnimatedCrossFade(
                  firstChild: Text(
                    widget.post.body,
                    maxLines: 5,
                    overflow: TextOverflow.fade,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  secondChild: Text(
                    widget.post.body,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  crossFadeState: _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
              ),
              const SizedBox(height: 24),

              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: widget.post.tags
                    .map(
                      (tag) => Chip(
                        label: Text(tag),
                        labelStyle: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                        backgroundColor: theme.colorScheme.primary.withOpacity(
                          0.1,
                        ),
                        side: BorderSide.none,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Icon(
                    Icons.thumb_up_alt_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.post.reactions?.likes ?? 0} Likes',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 24),
                  Icon(
                    Icons.thumb_down_alt_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.post.reactions?.dislikes ?? 0} Dislikes',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Spacer(),
                  BlocBuilder<FavoritesBloc, FavoritesState>(
                    builder: (context, state) {
                      final isFav = state.favorites.any(
                        (p) => p.id == widget.post.id,
                      );
                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: Colors.pink.shade300,
                        ),
                        onPressed: () {
                          context.read<FavoritesBloc>().add(
                            ToggleFavorite(widget.post),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 32),

              BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  if (state is PostLoaded) {
                    final morePosts = state.posts
                        .where((p) => p.id != widget.post.id)
                        .take(10)
                        .toList();
                    return MorePostsSection(morePosts: morePosts);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MorePostsSection extends StatelessWidget {
  const MorePostsSection({super.key, required this.morePosts});

  final List<Post> morePosts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('More Posts You May Like', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: morePosts.length,
          itemBuilder: (context, index) {
            final post = morePosts[index];
            return PostTile(post: post);
          },
          separatorBuilder: (context, index) => const Divider(),
        ),
      ],
    );
  }
}
