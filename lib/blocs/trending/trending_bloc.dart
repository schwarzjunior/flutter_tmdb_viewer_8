import 'package:rxdart/rxdart.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdb_viewer_8/blocs/bloc_base.dart';
import 'package:tmdb_viewer_8/blocs/trending/trending_bloc_state.dart';

class TrendingBloc extends BlocBase {
  TrendingBloc() : _apiTrending = ApiTrending();

  final ApiTrending _apiTrending;

  final BehaviorSubject<TrendingState> _trendingAllController = BehaviorSubject<TrendingState>();
  final BehaviorSubject<TrendingState> _trendingMovieController = BehaviorSubject<TrendingState>();
  final BehaviorSubject<TrendingState> _trendingTvController = BehaviorSubject<TrendingState>();
  final BehaviorSubject<TrendingState> _trendingPersonController = BehaviorSubject<TrendingState>();

  Stream<TrendingState> getOutState(TmdbTrendingMediaType mediaType) {
    return _getStreamControllerByType(mediaType).stream;
  }

  Future<void> loadTrending(TmdbTrendingMediaType mediaType) async {
    _getStreamControllerByType(mediaType)
        .sink
        .add(_buildStateByType(mediaType, TrendingStates.loading, null));
    // TODO: Remover atraso simulado de teste
    await Future.delayed(const Duration(seconds: 1));
    // TODO: Adicionar funcionalidade para obter o trandingWeek()
    final Trending trending = await _apiTrending.trendingDay(mediaType);
    _getStreamControllerByType(mediaType)
        .sink
        .add(_buildStateByType(mediaType, TrendingStates.done, trending));
  }

  Future<void> loadNextTrendingPage(TmdbTrendingMediaType mediaType, Trending trending) async {
    final Trending newTrending = await _apiTrending.trendingNextPage();
    // Atualizando o trending, adicionando os novos resultados
    trending = Trending(
      page: newTrending.page,
      totalPages: newTrending.totalPages,
      totalResults: newTrending.totalResults,
      results: trending.results + newTrending.results,
    );
    _getStreamControllerByType(mediaType)
        .sink
        .add(_buildStateByType(mediaType, TrendingStates.done, trending));
  }

  BehaviorSubject<TrendingState> _getStreamControllerByType(TmdbTrendingMediaType mediaType) {
    switch (mediaType) {
      case TmdbTrendingMediaType.movie:
        return _trendingMovieController;
      case TmdbTrendingMediaType.tv:
        return _trendingTvController;
      case TmdbTrendingMediaType.person:
        return _trendingPersonController;
      case TmdbTrendingMediaType.all:
      default:
        return _trendingAllController;
    }
  }

  TrendingState _buildStateByType(TmdbTrendingMediaType mediaType, TrendingStates state, Trending trending) {
    switch (mediaType) {
      case TmdbTrendingMediaType.movie:
        return TrendingMovieState(state: state, trending: trending);
      case TmdbTrendingMediaType.tv:
        return TrendingTvState(state: state, trending: trending);
      case TmdbTrendingMediaType.person:
        return TrendingPersonState(state: state, trending: trending);
      case TmdbTrendingMediaType.all:
      default:
        return TrendingAllState(state: state, trending: trending);
    }
  }

  @override
  void dispose() {
    _trendingAllController.close();
    _trendingMovieController.close();
    _trendingTvController.close();
    _trendingPersonController.close();
  }
}
