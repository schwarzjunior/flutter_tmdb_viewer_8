import 'package:meta/meta.dart';
import 'package:tmdb_api/tmdb_api.dart';

enum TrendingStates { idle, loading, error, done }

@immutable
abstract class TrendingState {
  const TrendingState(this.state, this.trending);

  final TrendingStates state;
  final Trending trending;
}

class TrendingAllState extends TrendingState {
  TrendingAllState({TrendingStates state, Trending trending}) : super(state, trending);
}

class TrendingMovieState extends TrendingState {
  TrendingMovieState({TrendingStates state, Trending trending}) : super(state, trending);
}

class TrendingTvState extends TrendingState {
  TrendingTvState({TrendingStates state, Trending trending}) : super(state, trending);
}

class TrendingPersonState extends TrendingState {
  TrendingPersonState({TrendingStates state, Trending trending}) : super(state, trending);
}
