import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdb_viewer_8/blocs/trending/trending_bloc.dart';
import 'package:tmdb_viewer_8/ui/common/media_tile/trending/trending_movie_tile.dart';
import 'package:tmdb_viewer_8/ui/common/media_tile/trending/trending_person_tile.dart';
import 'package:tmdb_viewer_8/ui/common/media_tile/trending/trending_tv_tile.dart';

class TrendingPageContent extends StatelessWidget {
  const TrendingPageContent({
    Key key,
    @required this.trending,
    @required this.bloc,
    @required this.mediaType,
    @required this.handleRefresh,
  })  : assert(trending != null),
        assert(bloc != null),
        assert(mediaType != null),
        assert(handleRefresh != null),
        super(key: key);

  final Trending trending;
  final TrendingBloc bloc;
  final TmdbTrendingMediaType mediaType;
  final Future<void> Function() handleRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: handleRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(8.0),
        itemCount: trending.results.length + (trending.hasNextPage ? 1 : 0),
        separatorBuilder: (context, index) => Divider(color: Colors.grey[800]),
        itemBuilder: (context, index) {
          if (index < trending.results.length) {
            return _buildTrendingMediatile(context, trending.results.elementAt(index));
          } else {
            bloc.loadNextTrendingPage(mediaType, trending);
            return _buildLoadingNextPageIndicator();
          }
        },
      ),
    );
  }

  Widget _buildTrendingMediatile(BuildContext context, TrendingMediaObject item) {
    if (item is TrendingMovie)
      return TrendingMovieTile(item);
    else if (item is TrendingTv)
      return TrendingTvTile(item);
    else if (item is TrendingPeople)
      return TrendingPersonTile(item);
    else
      return Container(
        height: 80.0,
        child: Center(
          child: Text('Unknown media type', style: Theme.of(context).textTheme.display1),
        ),
      );
  }

  Widget _buildLoadingNextPageIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      height: 40.0,
      width: 40.0,
      alignment: const Alignment(0, 0),
      child: const CircularProgressIndicator(
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
      ),
    );
  }
}
