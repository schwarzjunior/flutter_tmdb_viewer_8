import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdb_viewer_8/blocs/trending/trending_bloc.dart';
import 'package:tmdb_viewer_8/ui/screens/trending/models/tranding_tab_item.dart';
import 'package:tmdb_viewer_8/ui/screens/trending/pages/trending_tab_page.dart';

const List<TrendingTabItem> _tabs = const <TrendingTabItem>[
  const TrendingTabItem(title: 'ALL', iconData: Icons.trending_up, mediaType: TmdbTrendingMediaType.all),
  const TrendingTabItem(title: 'MOVIE', iconData: Icons.local_movies, mediaType: TmdbTrendingMediaType.movie),
  const TrendingTabItem(title: 'TV SHOW', iconData: Icons.live_tv, mediaType: TmdbTrendingMediaType.tv),
  const TrendingTabItem(title: 'PERSON', iconData: Icons.person, mediaType: TmdbTrendingMediaType.person),
];

class TrendingScreen extends StatefulWidget {
  @override
  _TrendingScreenState createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final TrendingBloc bloc = Provider.of<TrendingBloc>(context);

    return Theme(
      data: Theme.of(context).copyWith(
        appBarTheme: Theme.of(context).appBarTheme.copyWith(color: Colors.red),
        indicatorColor: Colors.black,
      ),
      child: DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Trending'),
            bottom: TabBar(
              isScrollable: false,
              tabs: _tabs.map((tab) => Tab(text: tab.title, icon: Icon(tab.iconData))).toList(),
            ),
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: _tabs.map((tab) => TrendingTabPage(bloc: bloc, tab: tab)).toList(),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
