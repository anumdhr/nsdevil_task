// lib/controllers/post_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/post_repository.dart';
import '../models/post.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository repository;
  final int limit = 10;

  List<Post> posts = [];
  int skip = 0;
  bool hasMore = true;
  bool isFetching = false;

  PostBloc(this.repository) : super(PostInitial()) {
    on<LoadPostsEvent>(_onLoadPosts);
    on<SearchPostsEvent>(_onSearchPosts);
  }

  Future<void> _onLoadPosts(
    LoadPostsEvent event,
    Emitter<PostState> emit,
  ) async {
    if (isFetching || !hasMore) return;

    try {
      isFetching = true;

      if (!event.loadMore) {
        emit(PostLoading());
        posts.clear();
        skip = 0;
        hasMore = true;
      } else {
        emit(PostLoadingMore(posts));
      }

      final newPosts = await repository.getPostsList(limit: limit, skip: skip);

      if (newPosts.isEmpty || newPosts.length < limit) {
        hasMore = false;
      }

      posts.addAll(newPosts);
      skip += newPosts.length;

      emit(posts.isEmpty ? PostEmpty() : PostLoaded(posts, hasMore: hasMore));
    } catch (e) {
      emit(PostError(e.toString()));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _onSearchPosts(
    SearchPostsEvent event,
    Emitter<PostState> emit,
  ) async {
    try {
      emit(PostLoading());
      final results = await repository.searchPosts(event.query);
      emit(results.isEmpty ? PostEmpty() : PostLoaded(results, hasMore: false));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }
}
