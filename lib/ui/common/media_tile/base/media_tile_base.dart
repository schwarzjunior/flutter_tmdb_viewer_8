import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_viewer_8/blocs/favorites/favorites_bloc.dart';
import 'package:tmdb_viewer_8/helpers/tmdb_helpers.dart';
import 'package:tmdb_viewer_8/models/tmdb_media_item.dart';
import 'package:tmdb_viewer_8/ui/common/media_tile/base/widgets/media_poster.dart';
import 'package:tmdb_viewer_8/ui/common/media_tile/base/widgets/media_tile.dart';

abstract class MediaTileBase extends StatelessWidget with TmdbHelpersMixin {
  const MediaTileBase({Key key, this.mediaItem}) : super(key: key);

  final TmdbMediaItem mediaItem;

  openDetails(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final FavoritesBloc favoritesBloc = Provider.of<FavoritesBloc>(context);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      excludeFromSemantics: true,
      onTap: () => openDetails(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          children: <Widget>[
            // TITLE, DESCRIPTION, POSTER
            Row(
              children: <Widget>[
                // TITLE, DESCRIPTION
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // TITLE
                        MediaTile(
                          title: mediaItem.name,
                          iconData: getMediaTypeIcon(mediaItem.mediaType),
                        ),
                        const SizedBox(height: 2.0),
                        // DESCRIPTION
                        Text(
                          mediaItem.description,
                          textAlign: TextAlign.justify,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ],
                    ),
                  ),
                ),
                // POSTER
                MediaPoster(
                  imageUrl: mediaItem.imageUrl,
                  alternativeIcon: getMediaTypeIcon(mediaItem.mediaType),
                ),
              ],
            ),
            // FAVORITE TOGGLER, YEAR
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // FAVORITE TOGGLER
                StreamBuilder<List<TmdbMediaItem>>(
                  stream: favoritesBloc.outFavorites,
                  initialData: favoritesBloc.favoritesList,
                  builder: (context, snapshot) {
                    final bool isFavorite = favoritesBloc.checkIsFavorite(mediaItem);
                    return GestureDetector(
                      onTap: () => favoritesBloc.toggleFavorite(mediaItem),
                      child: Icon(
                        isFavorite ? Icons.star : Icons.star_border,
                        color: isFavorite ? Colors.yellowAccent[700] : Colors.yellow[700],
                        size: 23.0,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10.0),
                // YEAR
                Text(
                  mediaItem?.dateTime?.year?.toString() ?? '',
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
