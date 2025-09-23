import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsdevil_project/module/homepage/bloc/favourite_bloc.dart';
import 'package:nsdevil_project/module/homepage/bloc/post_bloc.dart';
import 'package:nsdevil_project/module/homepage/bloc/post_event.dart';
import 'package:nsdevil_project/module/homepage/bloc/theme_cubit.dart';
import 'package:nsdevil_project/module/homepage/repository/post_repository.dart';
import 'package:nsdevil_project/module/homepage/screens/favourite_screen.dart';
import 'package:nsdevil_project/module/homepage/screens/post_detail_screen.dart';
import 'package:nsdevil_project/module/homepage/screens/post_list_screen.dart';
import 'package:nsdevil_project/module/utils/connectiviity.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final internet = InternetConnectivitySingleton();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final PostRepository repository = PostRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PostBloc(repository)..add(LoadPostsEvent()),
        ),
        BlocProvider(create: (_) => FavoritesBloc()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeState.mode,
            title: 'NSDevil Project',
            initialRoute: "postScreen",
            routes: {
              "postScreen": (context) => PostListScreen(),
              "postDetailScreen": (context) => PostDetailScreen(),
              "favoriteScreen": (context) => FavoritesScreen(),
            },
          );
        },
      ),
    );
  }
}
