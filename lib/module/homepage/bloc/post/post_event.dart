abstract class PostEvent {}

class LoadPostsEvent extends PostEvent {
  final bool loadMore;
  LoadPostsEvent({this.loadMore = false});
}

class SearchPostsEvent extends PostEvent {
  final String query;
  SearchPostsEvent(this.query);
}
