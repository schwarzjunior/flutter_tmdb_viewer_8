import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdb_viewer_8/blocs/favorites/favorites_bloc.dart';
import 'package:tmdb_viewer_8/helpers/formatter_helpers.dart';
import 'package:tmdb_viewer_8/helpers/tmdb_helpers.dart';
import 'package:tmdb_viewer_8/models/tmdb_media_item.dart';
import 'package:tmdb_viewer_8/ui/screens/details/movie/movie_details_page.dart';
import 'package:tmdb_viewer_8/ui/screens/details/person/person_details_page.dart';

class FavoritesTile extends StatelessWidget with TmdbHelpersMixin, FormatterHelpers {
  const FavoritesTile({
    Key key,
    @required this.bloc,
    @required this.mediaItem,
  })  : assert(bloc != null),
        assert(mediaItem != null),
        super(key: key);

  final FavoritesBloc bloc;
  final TmdbMediaItem mediaItem;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      dragStartBehavior: DragStartBehavior.down,
      key: UniqueKey(),
      background: Container(
        padding: const EdgeInsets.only(left: 10.0),
        alignment: const Alignment(-1, 0),
        color: Colors.red,
        child: Text(
          'Remove',
          style: Theme.of(context).textTheme.button.copyWith(color: Colors.white),
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          if (bloc.favoritesList.contains(mediaItem)) {
            bloc.toggleFavorite(mediaItem);
          }
        }
      },
      confirmDismiss: (direction) async => await _confirmDismissDialog(context, direction),
      direction: DismissDirection.startToEnd,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        child: InkWell(
          onTap: () {
            final Widget page = _getMediaItemPage();
            if (page != null) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => page,
              ));
            }
          },
          child: Container(
            height: 50.0,
            child: Row(
              children: <Widget>[
                _buildMediaImage(context),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        mediaItem.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.title.copyWith(
                              color: Theme.of(context).textTheme.title.color.withOpacity(0.7),
                            ),
                      ),
                      Text(
                        capitalizeFirstLetter(enumValueToString(mediaItem.mediaType)),
                        style: Theme.of(context).textTheme.subtitle.copyWith(
                              color: Theme.of(context).textTheme.subtitle.color.withOpacity(0.6),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getMediaItemPage() {
    switch (mediaItem.mediaType) {
      case TmdbMediaType.movie:
//        return null;
        return MovieDetailsPage(mediaItem.id);
      case TmdbMediaType.tv:
        return null;
      //return TvDetailsPage(mediaItem.id);
      case TmdbMediaType.person:
//        return null;
        return PersonDetailsPage(mediaItem.id);
      case TmdbMediaType.other:
      default:
        return null;
    }
  }

  Future<bool> _confirmDismissDialog(BuildContext context, DismissDirection direction) async {
    final TextStyle titleTextStyle =
        Theme.of(context)?.dialogTheme?.titleTextStyle ?? Theme.of(context).textTheme.title;
    final TextStyle contentTextStyle =
        Theme.of(context)?.dialogTheme?.contentTextStyle ?? Theme.of(context).textTheme.subhead;

    final bool result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          titleTextStyle: titleTextStyle.copyWith(
            color: titleTextStyle.color.withOpacity(0.6),
          ),
          contentTextStyle: contentTextStyle.copyWith(
            fontWeight: FontWeight.w600,
            color: contentTextStyle.color.withOpacity(0.5),
          ),
          elevation: 10.0,
          title: Text('Remove favorite:'),
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildDismissDialogMediaImage(context),
                Expanded(
                  child: Text(
                    mediaItem.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop<bool>(true),
              child: const Text('REMOVE'),
              color: Colors.blue,
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop<bool>(false),
              child: const Text('CANCEL'),
            ),
          ],
        );
      },
    );

    return result;
  }

  Widget _buildDismissDialogMediaImage(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12.0),
      child: mediaItem.imageUrl != null
          ? Image.network(
              mediaItem.imageUrl,
              fit: BoxFit.cover,
            )
          : Icon(
              getMediaTypeIcon(mediaItem.mediaType),
              size: 35.0,
              color: Theme.of(context).iconTheme.color.withOpacity(0.5),
            ),
    );
  }

  Widget _buildMediaImage(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6.0),
      child: AspectRatio(
        aspectRatio: 16.0 / 9.0,
        child: mediaItem.imageUrl != null
            ? Image.network(
                mediaItem.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, chunkEvent) => Center(child: child),
              )
            : Icon(
                getMediaTypeIcon(mediaItem.mediaType),
                size: 40.0,
                color: Colors.black.withAlpha(100),
              ),
      ),
    );
  }
}
