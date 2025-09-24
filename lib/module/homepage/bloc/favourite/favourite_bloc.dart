import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsdevil_project/module/homepage/bloc/favourite/favourite_event.dart';
import 'package:nsdevil_project/module/homepage/bloc/favourite/favourite_state.dart';
import 'package:nsdevil_project/module/homepage/models/post.dart';
import 'package:nsdevil_project/module/utils/cache_manager.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final cacheManager = FavoritesCacheManager.instance;
  final String cacheKey = "favorites.json";

  FavoritesBloc() : super(const FavoritesState([])) {
    on<ToggleFavorite>(_onToggleFavorite);
    on<LoadFavorites>(_onLoadFavorites);
    on<DeleteFavorite>(_onDeleteFavorite);

    add(LoadFavorites());
  }

  void _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final cachedFile = await cacheManager.getFileFromCache(cacheKey);
      if (cachedFile != null) {
        final jsonString = await cachedFile.file.readAsString();
        final List data = jsonDecode(jsonString);
        final favorites = data.map((e) => Post.fromJson(e)).toList();

        emit(state.copyWith(favorites: favorites));
      } else {
        emit(state.copyWith(favorites: []));
      }
    } catch (e) {
      emit(state.copyWith(favorites: []));
    }
  }

  void _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    final updatedFavorites = List<Post>.from(state.favorites);
    if (updatedFavorites.any((p) => p.id == event.post.id)) {
      updatedFavorites.removeWhere((p) => p.id == event.post.id);
    } else {
      updatedFavorites.add(event.post);
    }
    emit(state.copyWith(favorites: updatedFavorites));
    await _saveToCache(updatedFavorites);
  }

  void _onDeleteFavorite(
    DeleteFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    final updatedFavorites = List<Post>.from(state.favorites)
      ..removeWhere((p) => p.id == event.post.id);
    emit(state.copyWith(favorites: updatedFavorites));
    await _saveToCache(updatedFavorites);
  }

  Future<void> _saveToCache(List<Post> favorites) async {
    final jsonString = jsonEncode(favorites.map((p) => p.toJson()).toList());

    final bytes = utf8.encode(jsonString);

    await cacheManager.putFile(
      cacheKey,
      bytes,
      maxAge: const Duration(days: 30),
    );
  }

  bool isFavorite(Post post) => state.favorites.any((p) => p.id == post.id);

  void loadFavorites() => add(LoadFavorites());
}
