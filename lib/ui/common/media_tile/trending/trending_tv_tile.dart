import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdb_viewer_8/models/tmdb_media_item.dart';
import 'package:tmdb_viewer_8/ui/common/media_tile/base/media_tile_base.dart';

class TrendingTvTile extends MediaTileBase {
  TrendingTvTile(this.tv, {Key key})
      : super(
            key: key,
            mediaItem: TmdbMediaItem(
              id: tv.id,
              name: tv.name,
              description: tv.overview,
              dateTime: tv.firstAirDate,
              imageUrl: tv.getBackdropUrl() ?? tv.getPosterUrl(),
              homepage: null,
              mediaType: tv.mediaType,
            ));

  final TrendingTv tv;

  @override
  openDetails(BuildContext context) {
    return null;
  }
}
