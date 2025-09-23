import 'package:nsdevil_project/module/homepage/models/post.dart';

abstract class FavoritesEvent {}

class ToggleFavorite extends FavoritesEvent {
  final Post post;
  ToggleFavorite(this.post);
}

class DeleteFavorite extends FavoritesEvent {
  final Post post;
  DeleteFavorite(this.post);
}

class LoadFavorites extends FavoritesEvent {}
