import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsdevil_project/module/homepage/bloc/favourite/favourite_bloc.dart';
import 'package:nsdevil_project/module/homepage/bloc/post/post_bloc.dart';
import 'package:nsdevil_project/module/homepage/bloc/theme/theme_cubit.dart';
import 'package:nsdevil_project/module/homepage/repository/post_repository.dart';
import 'module/homepage/bloc/connectivity_cubit/connectivity_cubit.dart';
import 'module/homepage/bloc/post/post_event.dart';
import 'module/services/navigation_services.dart';
import 'module/utils/app_theme.dart';
import 'module/utils/nav_locator.dart';
import 'module/utils/route.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
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
        BlocProvider(create: (_) => ConnectivityCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: locator<NavigationService>().navigatorKey,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.mode,
            title: 'NSDevil Project',
            initialRoute: AppRoutes.splashScreen,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}
