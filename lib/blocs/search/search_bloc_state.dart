enum SearchState { idle, loading, error, done }

class SearchBlocState {
  SearchBlocState(this.state, {this.errorMessage});

  SearchState state;
  String errorMessage;
}
