import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmdb_viewer_8/blocs/bloc_base.dart';
import 'package:tmdb_viewer_8/models/tmdb_media_item.dart';

class FavoritesBloc extends BlocBase {
  static const _favoritesKey = 'favorites';

  final BehaviorSubject<List<TmdbMediaItem>> _favoritesController =
      BehaviorSubject<List<TmdbMediaItem>>.seeded([]);

  Stream<List<TmdbMediaItem>> get outFavorites => _favoritesController.stream;

  FavoritesBloc() {
    _loadFavorites();
  }

  Map<String, TmdbMediaItem> _favorites;

  List<TmdbMediaItem> get favoritesList => _favorites.values.toList();

  bool checkIsFavorite(TmdbMediaItem mediaItem) => _favorites.containsKey(mediaItem.id.toString());

  void toggleFavorite(TmdbMediaItem mediaItem) {
    if (_favorites.containsKey(mediaItem.id.toString())) {
      _favorites.remove(mediaItem.id.toString());
    } else {
      _favorites[mediaItem.id.toString()] = mediaItem;
    }

    _saveFavorites();
    _favoritesController.sink.add(_favorites.values.toList());
  }

  void _loadFavorites() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey(_favoritesKey)) {
        _favorites = jsonDecode(prefs.getString(_favoritesKey)).map((k, v) {
          return MapEntry(k, TmdbMediaItem.fromJson(v));
        }).cast<String, TmdbMediaItem>();
      } else {
        _favorites = {};
      }
      _favoritesController.sink.add(_favorites.values.toList());
    });
  }

  void _saveFavorites() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(_favoritesKey, jsonEncode(_favorites));
    });
  }

  @override
  void dispose() {
    _favoritesController.close();
  }
}
