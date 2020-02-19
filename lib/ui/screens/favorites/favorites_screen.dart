import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_viewer_8/blocs/favorites/favorites_bloc.dart';
import 'package:tmdb_viewer_8/models/tab_bar_item.dart';
import 'package:tmdb_viewer_8/models/tmdb_media_item.dart';
import 'package:tmdb_viewer_8/ui/screens/favorites/pages/favorites_tab_page.dart';

const List<TabBarItem> _tabs = const <TabBarItem>[
  const TabBarItem(text: 'ALL', iconData: Icons.play_arrow, type: TabBarItemType.all),
  const TabBarItem(text: 'MOVIE', iconData: Icons.local_movies, type: TabBarItemType.movie),
  const TabBarItem(text: 'TV SHOW', iconData: Icons.live_tv, type: TabBarItemType.tv),
  const TabBarItem(text: 'PERSON', iconData: Icons.person, type: TabBarItemType.person),
];

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final FavoritesBloc bloc = Provider.of<FavoritesBloc>(context);

    return Theme(
      data: Theme.of(context).copyWith(
        appBarTheme: Theme.of(context).appBarTheme.copyWith(color: Colors.yellow[800]),
      ),
      child: StreamBuilder<List<TmdbMediaItem>>(
        stream: bloc.outFavorites,
        initialData: bloc.favoritesList,
        builder: (context, snapshot) {
          return DefaultTabController(
            length: _tabs.length,
            child: Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('Favorites'),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Total:',
                            style: Theme.of(context).primaryTextTheme.title,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            snapshot.data.length.toString(),
                            style: Theme.of(context).primaryTextTheme.title.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                bottom: TabBar(
                  isScrollable: false,
                  tabs: _tabs.map((tab) => Tab(text: tab.text, icon: Icon(tab.iconData))).toList(),
                ),
              ),
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: _tabs
                    .map((tab) => FavoritesTabPage(bloc: bloc, mediaItems: snapshot.data, tab: tab))
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
