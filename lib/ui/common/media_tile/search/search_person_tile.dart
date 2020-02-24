import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdb_viewer_8/models/tmdb_media_item.dart';
import 'package:tmdb_viewer_8/ui/common/media_tile/base/media_tile_base.dart';
import 'package:tmdb_viewer_8/ui/screens/details/person/person_details_page.dart';

class SearchPersonTile extends MediaTileBase {
  SearchPersonTile(this.person, {Key key}) : super(key: key, mediaItem: TmdbMediaItem.fromPerson(person));

  final MultiSearchPerson person;

  @override
  openDetails(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PersonDetailsPage(person.id),
    ));
  }
}
