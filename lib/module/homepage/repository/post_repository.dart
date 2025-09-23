// lib/repository/post_repository.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:nsdevil_project/module/utils/connectiviity.dart';
import '../models/post.dart';

class PostRepository {
  final Dio dio = Dio();
  final DefaultCacheManager cacheManager = DefaultCacheManager();
  final InternetConnectivitySingleton connectivity =
      InternetConnectivitySingleton();

  Future<List<Post>> getPostsList({int limit = 10, int skip = 0}) async {
    final connected = await connectivity.waitForInternet();
    if (connected) {
      final response = await dio.get(
        'https://dummyjson.com/posts',
        queryParameters: {'limit': limit, 'skip': skip},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final posts = (data['posts'] as List)
            .map((e) => Post.fromJson(e))
            .toList();

        if (skip == 0) {
          await cacheManager.putFile(
            'cached_posts',
            utf8.encode(jsonEncode(data)),
            fileExtension: 'json',
            maxAge: Duration(days: 30),
          );
        }

        return posts;
      } else {
        throw Exception('Failed to fetch posts');
      }
    } else {
      if (skip == 0) {
        final file = await cacheManager.getFileFromCache('cached_posts');
        if (file != null) {
          final cachedData = jsonDecode(
            utf8.decode(await file.file.readAsBytes()),
          );
          final posts = (cachedData['posts'] as List)
              .map((e) => Post.fromJson(e))
              .toList();
          return posts;
        } else {
          throw 'No Internet Connection';
        }
      }

      return [];
    }
  }

  Future<List<Post>> searchPosts(String query) async {
    if (!connectivity.isConnected) {
      throw 'No internet connection';
    }

    try {
      final response = await dio.get(
        'https://dummyjson.com/posts/search',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final posts = (data['posts'] as List)
            .map((postData) => Post.fromJson(postData))
            .toList();
        return posts;
      } else {
        throw Exception(
          'Failed to search posts: Status code ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw 'Failed to search posts: ${e.message}';
    }
  }
}
