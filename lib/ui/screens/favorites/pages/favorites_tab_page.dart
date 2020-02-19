import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdb_viewer_8/blocs/favorites/favorites_bloc.dart';
import 'package:tmdb_viewer_8/models/tab_bar_item.dart';
import 'package:tmdb_viewer_8/models/tmdb_media_item.dart';
import 'package:tmdb_viewer_8/ui/common/custom_widgets.dart' show BigIconMessage;
import 'package:tmdb_viewer_8/ui/screens/favorites/pages/widgets/favorite_tile.dart';

class FavoritesTabPage extends StatefulWidget {
  const FavoritesTabPage({
    Key key,
    @required this.bloc,
    @required this.mediaItems,
    @required this.tab,
  })  : assert(bloc != null),
        assert(mediaItems != null),
        assert(tab != null),
        super(key: key);

  final FavoritesBloc bloc;
  final List<TmdbMediaItem> mediaItems;
  final TabBarItem tab;

  @override
  _FavoritesTabPageState createState() => _FavoritesTabPageState();
}

class _FavoritesTabPageState extends State<FavoritesTabPage> {
  FavoritesBloc get bloc => widget.bloc;

  List<TmdbMediaItem> get mediaItems => widget.mediaItems;

  TabBarItem get tab => widget.tab;

  @override
  Widget build(BuildContext context) {
    if (filteredMediaItems.isEmpty) {
      return BigIconMessage(
        iconData: Icons.layers_clear,
        message: 'Nenhum ${tab.text} encontrado',
      );
    }

    return ListView.separated(
//      padding: const EdgeInsets.symmetric(vertical: 2.0),
      itemCount: filteredMediaItems.length,
      separatorBuilder: (context, index) => Divider(color: Colors.grey[800], height: 0.0),
      itemBuilder: (context, index) {
        return FavoritesTile(
          bloc: bloc,
          mediaItem: filteredMediaItems.elementAt(index),
        );
      },
    );
  }

  List<TmdbMediaItem> get filteredMediaItems {
    if (tab.type == TabBarItemType.all) return mediaItems;

    TmdbMediaType mediaType;
    if (tab.type == TabBarItemType.movie) {
      mediaType = TmdbMediaType.movie;
    } else if (tab.type == TabBarItemType.tv) {
      mediaType = TmdbMediaType.tv;
    } else if (tab.type == TabBarItemType.person) {
      mediaType = TmdbMediaType.person;
    }

    return mediaItems.where((item) => item.mediaType == mediaType).toList();
  }
}
