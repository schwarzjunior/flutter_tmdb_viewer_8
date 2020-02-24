import 'package:rxdart/rxdart.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdb_viewer_8/blocs/bloc_base.dart';
import 'package:tmdb_viewer_8/blocs/search/search_bloc_state.dart';

class SearchBloc extends BlocBase {
  SearchBloc() : _apiSearch = ApiSearch();

  final ApiSearch _apiSearch;
  final BehaviorSubject<SearchBlocState> _stateController =
      BehaviorSubject<SearchBlocState>.seeded(SearchBlocState(SearchState.idle));
  final BehaviorSubject<MultiSearch> _searchController = BehaviorSubject<MultiSearch>();

  Stream<SearchBlocState> get outState => _stateController.stream;
  Stream<MultiSearch> get outSearch => _searchController.stream;

  MultiSearch _multiSearch;

  void searchQuery(String query) async {
    _sendState(SearchState.loading);
    _multiSearch = await _apiSearch.multiSearch(query);
    _sendState(SearchState.done);
    _searchController.sink.add(_multiSearch);
  }

  void getNextPage() async {
    MultiSearch newMultiSearch = await _apiSearch.multiSearchNextPage();
    _multiSearch = MultiSearch(
      page: newMultiSearch.page,
      totalPages: newMultiSearch.totalPages,
      totalResults: newMultiSearch.totalResults,
      results: _multiSearch.results + newMultiSearch.results,
    );
    _searchController.sink.add(_multiSearch);
  }

  void _sendState(SearchState state, [String errorMessage]) {
    _stateController.sink.add(SearchBlocState(state, errorMessage: errorMessage));
  }

  @override
  void dispose() {
    _stateController.close();
    _searchController.close();
  }
}
