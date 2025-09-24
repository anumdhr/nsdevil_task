// lib/controllers/post_state.dart

import 'package:nsdevil_project/module/homepage/models/post.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoadingMore extends PostState {
  final List<Post> oldPosts;
  PostLoadingMore(this.oldPosts);
}

class PostLoaded extends PostState {
  final List<Post> posts;
  final bool hasMore;
  PostLoaded(this.posts, {this.hasMore = true});
}

class PostEmpty extends PostState {}

class PostError extends PostState {
  final String message;
  PostError(this.message);
}
