import 'package:flutter/material.dart';
import 'package:tmdb_viewer_8/blocs/trending/trending_bloc.dart';
import 'package:tmdb_viewer_8/blocs/trending/trending_bloc_state.dart';
import 'package:tmdb_viewer_8/ui/screens/trending/models/tranding_tab_item.dart';
import 'package:tmdb_viewer_8/ui/screens/trending/pages/widgets/trending_loading.dart';
import 'package:tmdb_viewer_8/ui/screens/trending/pages/widgets/trending_page_content.dart';

class TrendingTabPage extends StatefulWidget {
  const TrendingTabPage({Key key, this.bloc, this.tab}) : super(key: key);

  final TrendingBloc bloc;
  final TrendingTabItem tab;

  @override
  _TrendingTabPageState createState() => _TrendingTabPageState();
}

class _TrendingTabPageState extends State<TrendingTabPage> {
  TrendingBloc get bloc => widget.bloc;

  TrendingTabItem get tab => widget.tab;

  @override
  void initState() {
    super.initState();

    _loadTrending();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TrendingState>(
      stream: bloc.getOutState(tab.mediaType),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        if (snapshot.data.state == TrendingStates.loading)
          return TrendingLoading(
            title: tab.title,
            iconData: tab.iconData,
          );

        if (snapshot.data.state == TrendingStates.done)
          return TrendingPageContent(
            trending: snapshot.data.trending,
            bloc: bloc,
            mediaType: tab.mediaType,
            handleRefresh: _handleRefresh,
          );

        return Container();
      },
    );
  }

  Future<void> _handleRefresh() async {
    await _loadTrending();
  }

  Future<void> _loadTrending() async {
    bloc.loadTrending(tab.mediaType);
  }
}
