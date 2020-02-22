import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdb_viewer_8/blocs/bottom_app_bar_bloc/bottom_app_bar_bloc.dart';
import 'package:tmdb_viewer_8/blocs/favorites/favorites_bloc.dart';
import 'package:tmdb_viewer_8/blocs/trending/trending_bloc.dart';
import 'package:tmdb_viewer_8/global/app_themes.dart';
import 'package:tmdb_viewer_8/ui/screens/start/start_screen.dart';

void main() {
  TmdbApiController.init(
    apiKey: 'ffea4ca1099c6f945cfe912e08056be2',
    includeAdult: true,
    language: TmdbConfigurationLanguage.pt_BR,
  );
  Intl.defaultLocale = 'pt_BR';
  initializeDateFormatting(Intl.defaultLocale).then((_) {
    // final DynamicThemeController dynamicThemeController = DynamicThemeController();
    // runApp(TmdbViewer8App(themeController: dynamicThemeController));
    runApp(TmdbViewer8App());
  });
}

class TmdbViewer8App extends StatelessWidget {
  const TmdbViewer8App({Key key}) : super(key: key);

  // final DynamicThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<BottomAppBarBloc>(
          create: (_) => BottomAppBarBloc(),
          dispose: (context, value) => value.dispose(),
        ),
        Provider<FavoritesBloc>(
          create: (_) => FavoritesBloc(),
          dispose: (context, value) => value.dispose(),
        ),
        Provider<TrendingBloc>(
          create: (_) => TrendingBloc(),
          dispose: (context, value) => value.dispose(),
        ),
      ],
      child: MaterialMainApp(),
    );
  }
}

class MaterialMainApp extends StatelessWidget {
  const MaterialMainApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TMDb Viewer 8',
      theme: theme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: StartScreen(),
    );
  }
}
