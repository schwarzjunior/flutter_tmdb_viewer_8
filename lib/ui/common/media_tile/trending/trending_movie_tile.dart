import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdb_viewer_8/models/tmdb_media_item.dart';
import 'package:tmdb_viewer_8/ui/common/media_tile/base/media_tile_base.dart';
import 'package:tmdb_viewer_8/ui/screens/details/movie/movie_details_page.dart';

class TrendingMovieTile extends MediaTileBase {
  TrendingMovieTile(this.movie, {Key key})
      : super(
            key: key,
            mediaItem: TmdbMediaItem(
              id: movie.id,
              name: movie.title,
              description: movie.overview,
              dateTime: movie.releaseDate,
              imageUrl: movie.getBackdropUrl() ?? movie.getPosterUrl(),
              homepage: null,
              mediaType: movie.mediaType,
            ));

  final TrendingMovie movie;

  @override
  openDetails(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MovieDetailsPage(movie.id),
    ));
  }
}
