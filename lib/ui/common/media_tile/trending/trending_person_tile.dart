import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdb_viewer_8/models/tmdb_media_item.dart';
import 'package:tmdb_viewer_8/ui/common/media_tile/base/media_tile_base.dart';

class TrendingPersonTile extends MediaTileBase {
  TrendingPersonTile(this.person, {Key key})
      : super(
            key: key,
            mediaItem: TmdbMediaItem(
              id: person.id,
              name: person.name,
              description: person.knownForDepartment,
              dateTime: null,
              imageUrl: person.getProfileUrl(),
              homepage: null,
              mediaType: person.mediaType,
            ));

  final TrendingPeople person;

  @override
  openDetails(BuildContext context) {}
}
