import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';

class MultiSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Future.delayed(Duration.zero).then((_) {
      close(context, query.isEmpty ? null : query);
    });
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return Container();

    return FutureBuilder<MultiSearch>(
      future: suggestions(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: const CircularProgressIndicator());

        return ListView.builder(
          itemCount: snapshot.data.results.length,
          itemBuilder: (context, index) {
            final MultiSearchMediaObject item = snapshot.data.results.elementAt(index);
            IconData icon;
            String title;

            if (item is MultiSearchMovie) {
              icon = Icons.local_movies;
              title = item.title;
            } else if (item is MultiSearchTv) {
              icon = Icons.live_tv;
              title = item.name;
            } else if (item is MultiSearchPerson) {
              icon = Icons.person;
              title = item.name;
            } else {
              icon = Icons.play_arrow;
              title = '';
            }

            return ListTile(
              title: Text(title),
              leading: Icon(icon),
              onTap: () => close(context, title),
            );
          },
        );
      },
    );
  }

  @override
  String get searchFieldLabel => 'Search query';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark
        ? _getThemeDark(context)
        : _getThemeLight(context);
  }

  Future<MultiSearch> suggestions(String query) async {
    final ApiSearch apiSearch = ApiSearch();
    return apiSearch.multiSearch(query);
  }

  static ThemeData _getThemeLight(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return theme.copyWith(
      primaryColorBrightness: Brightness.light,
      primaryColor: Colors.white,
      primaryIconTheme: theme.iconTheme.copyWith(color: Colors.grey[400]),
      textTheme: theme.textTheme.copyWith(
        title: theme.textTheme.title.copyWith(
          color: Colors.black,
          decorationColor: Colors.black,
        ),
      ),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        hintStyle: theme.textTheme.title.copyWith(color: Colors.grey[400]),
      ),
    );
  }

  static ThemeData _getThemeDark(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return theme.copyWith(
      primaryColorBrightness: Brightness.dark,
      primaryColor: Colors.black,
      primaryIconTheme: theme.iconTheme.copyWith(color: Colors.grey[400]),
      textTheme: theme.textTheme.copyWith(
        title: theme.textTheme.title.copyWith(
          color: Colors.blue,
          decorationColor: Colors.blueAccent,
        ),
      ),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        hintStyle: theme.textTheme.title.copyWith(color: Colors.grey[600]),
      ),
    );
  }
}
