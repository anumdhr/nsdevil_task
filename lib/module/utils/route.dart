import 'package:flutter/material.dart';
import 'package:nsdevil_project/module/homepage/models/post.dart';

import 'package:nsdevil_project/module/homepage/screens/splash_screen.dart';
import 'package:nsdevil_project/module/homepage/screens/favourite_screen.dart';
import 'package:nsdevil_project/module/homepage/screens/post_detail_screen.dart';
import 'package:nsdevil_project/module/homepage/screens/post_list_screen.dart';

class AppRoutes {
  static const String splashScreen = '/';

  static const String postListScreen = '/home';
  static const String postDetailScreen = '/postDetail';
  static const String favoriteScreen = '/favorites';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case postListScreen:
        return MaterialPageRoute(builder: (_) => PostListScreen());

      case favoriteScreen:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FavoritesScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        );

      case postDetailScreen:
        if (args is Post) {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) => PostDetailScreen(post: args),
            transitionsBuilder: (_, animation, __, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;
              final tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          );
        }
        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('ERROR: Route not found!')),
        );
      },
    );
  }
}
