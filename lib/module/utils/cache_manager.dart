import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class FavoritesCacheManager extends CacheManager {
  static const key = "favoritesCache";

  FavoritesCacheManager()
    : super(
        Config(
          key,
          stalePeriod: const Duration(days: 30),
          maxNrOfCacheObjects: 20,
          repo: JsonCacheInfoRepository(databaseName: key),
          fileService: HttpFileService(),
        ),
      );

  static FavoritesCacheManager instance = FavoritesCacheManager();
}
