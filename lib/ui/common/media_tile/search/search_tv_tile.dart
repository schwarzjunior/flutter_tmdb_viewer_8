import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdb_viewer_8/models/tmdb_media_item.dart';
import 'package:tmdb_viewer_8/ui/common/media_tile/base/media_tile_base.dart';
import 'package:tmdb_viewer_8/ui/screens/details/tv/tv_details_page.dart';

class SearchTvTile extends MediaTileBase {
  SearchTvTile(this.tv, {Key key}) : super(key: key, mediaItem: TmdbMediaItem.fromTv(tv));

  final MultiSearchTv tv;

  @override
  openDetails(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TvDetailsPage(tv.id),
    ));
  }
}
