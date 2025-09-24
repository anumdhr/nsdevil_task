import 'package:equatable/equatable.dart';
import 'package:nsdevil_project/module/homepage/models/post.dart';

class FavoritesState extends Equatable {
  final List<Post> favorites;

  const FavoritesState(this.favorites);

  @override
  List<Object> get props => [favorites];

  FavoritesState copyWith({List<Post>? favorites}) {
    return FavoritesState(favorites ?? this.favorites);
  }
}
