import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsdevil_project/module/homepage/bloc/favourite_event.dart';
import 'package:nsdevil_project/module/homepage/bloc/favourite_state.dart';
import 'package:nsdevil_project/module/homepage/models/post.dart';
import 'package:nsdevil_project/module/utils/cache_manager.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final cacheManager = FavoritesCacheManager.instance;
  final String cacheKey = "favorites.json";

  FavoritesBloc() : super(FavoritesState([])) {
    on<ToggleFavorite>(_onToggleFavorite);
    on<LoadFavorites>(_onLoadFavorites);
    on<DeleteFavorite>(_onDeleteFavorite);
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
        emit(FavoritesState(favorites));
      } else {
        emit(FavoritesState([]));
      }
    } catch (e) {
      emit(FavoritesState([]));
    }
  }

  void _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    final updated = List<Post>.from(state.favorites);
    if (updated.any((p) => p.id == event.post.id)) {
      updated.removeWhere((p) => p.id == event.post.id);
    } else {
      updated.add(event.post);
    }
    emit(FavoritesState(updated));
    await _saveToCache(updated);
  }

  void _onDeleteFavorite(
    DeleteFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    final updated = List<Post>.from(state.favorites)
      ..removeWhere((p) => p.id == event.post.id);
    emit(FavoritesState(updated));
    await _saveToCache(updated);
  }

  Future<void> _saveToCache(List<Post> favorites) async {
    final jsonString = jsonEncode(
      favorites
          .map(
            (p) => {
              "id": p.id,
              "title": p.title,
              "body": p.body,
              "tags": p.tags,
              "reactions": p.reactions,
              "userId": p.userId,
            },
          )
          .toList(),
    );

    final bytes = Uint8List.fromList(jsonString.codeUnits);
    await cacheManager.putFile(cacheKey, bytes, maxAge: Duration(days: 30));
  }

  bool isFavorite(Post post) => state.favorites.any((p) => p.id == post.id);

  void loadFavorites() => add(LoadFavorites());
}
