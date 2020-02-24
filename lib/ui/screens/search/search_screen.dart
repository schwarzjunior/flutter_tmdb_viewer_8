import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdb_viewer_8/blocs/search/search_bloc.dart';
import 'package:tmdb_viewer_8/blocs/search/search_bloc_state.dart';
import 'package:tmdb_viewer_8/delegates/multi_search_delegate.dart';
import 'package:tmdb_viewer_8/ui/common/custom_widgets.dart';
import 'package:tmdb_viewer_8/ui/common/media_tile/search/search_movie_tile.dart';
import 'package:tmdb_viewer_8/ui/common/media_tile/search/search_person_tile.dart';
import 'package:tmdb_viewer_8/ui/common/media_tile/search/search_tv_tile.dart';
import 'package:tmdb_viewer_8/ui/screens/search/widgets/top_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final SearchBloc searchBloc = Provider.of<SearchBloc>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Search'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _startSearchDialog(searchBloc),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          TopBar(),
          Expanded(
            child: StreamBuilder<SearchBlocState>(
              stream: searchBloc.outState,
              initialData: SearchBlocState(SearchState.idle),
              builder: (context, snapshot) {
                switch (snapshot.data.state) {
                  case SearchState.idle:
                    return _idleWidget();
                  case SearchState.loading:
                    return _loadingWidget();
                  case SearchState.done:
                    return _doneWidget(context, searchBloc);
                  case SearchState.error:
                  default:
                    return _errorWidget();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadingWidget() {
    return const Center(child: const CircularProgressIndicator());
  }

  Widget _idleWidget() {
    return BigIconMessage(
      iconData: Icons.search,
      message: '',
    );
  }

  Widget _doneWidget(BuildContext context, SearchBloc searchBloc) {
    return StreamBuilder<MultiSearch>(
      stream: searchBloc.outSearch,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return BigIconMessage(
            iconData: Icons.search,
            message: '',
          );
        }

        if (snapshot.data.results.isEmpty) {
          return BigIconMessage(
            iconData: Icons.sentiment_dissatisfied,
            message: 'Nenhum resultado encontrado',
          );
        }

        final MultiSearch multiSearch = snapshot.data;
        return ListView.separated(
          padding: const EdgeInsets.all(8.0),
          itemCount: multiSearch.results.length + (multiSearch.hasNextPage ? 1 : 0),
          separatorBuilder: (context, index) => Divider(color: Colors.grey[800]),
          itemBuilder: (context, index) {
            if (index < multiSearch.results.length) {
              final item = multiSearch.results.elementAt(index);
              if (item is MultiSearchMovie) {
                return SearchMovieTile(item);
              } else if (item is MultiSearchTv) {
                return SearchTvTile(item);
              } else if (item is MultiSearchPerson) {
                return SearchPersonTile(item);
              } else {
                return Text('Other');
              }
            } else {
              searchBloc.getNextPage();
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                height: 40.0,
                width: 40.0,
                alignment: const Alignment(0.0, 0.0),
                child: const CircularProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _errorWidget() {
    return Container();
  }

  Future<void> _startSearchDialog(SearchBloc searchBloc) async {
    String query = await showSearch(context: context, delegate: MultiSearchDelegate());
    if (query != null) {
      searchBloc.searchQuery(query);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
