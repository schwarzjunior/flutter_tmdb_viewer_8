import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdb_viewer_8/global/app_defaults.dart';
import 'package:tmdb_viewer_8/helpers/tmdb_helpers.dart';
import 'package:tmdb_viewer_8/models/tmdb_media_item.dart';
import 'package:tmdb_viewer_8/ui/common/widgets/custom_expansio_tile.dart';
import 'package:tmdb_viewer_8/ui/screens/details/base/delegates/media_details_sliver_delegate.dart';
import 'package:tmdb_viewer_8/ui/screens/details/base/media_details_page_mixin.dart';
import 'package:tmdb_viewer_8/ui/screens/details/person/person_details_page.dart';

class _CustomExpansionTile2 extends CustomExpansionTile {
  _CustomExpansionTile2(BuildContext context, this.title, this.children, {Key key})
      : super(
          key: key,
          contentPadding: const EdgeInsets.all(16.0),
          decoration: getCustomExpansionTileDecoration(context),
          titleStyle: customExpansionTileTitleStyle,
          title: title,
          children: children,
        );

  final String title;
  final List<Widget> children;
}

class _CustomExpansionTile extends StatelessWidget {
  const _CustomExpansionTile(this.title, this.children, {Key key}) : super(key: key);

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      contentPadding: const EdgeInsets.all(16.0),
      decoration: getCustomExpansionTileDecoration(context),
      titleStyle: customExpansionTileTitleStyle,
      title: title,
      children: children,
    );
  }
}

class TvEpisodeDetailsPage extends StatefulWidget {
  const TvEpisodeDetailsPage(this.tv, this.tvSeason, this.episodeNumber, {Key key})
      : super(key: key);

  final Tv tv;
  final TvSeason tvSeason;
  final int episodeNumber;

  @override
  _TvEpisodeDetailsPageState createState() => _TvEpisodeDetailsPageState();
}

class _TvEpisodeDetailsPageState extends State<TvEpisodeDetailsPage>
    with MediaDetailsPageMixin<TvEpisode, TvEpisodeDetailsPage>, TmdbHelpersMixin {
  Widget _buildOverview() {
    return _CustomExpansionTile(
      'Overview',
      <Widget>[
        Text(
          details.overview,
          textAlign: TextAlign.justify,
          style: textTheme.body1,
        ),
      ],
    );
  }

  /* Widget _buildOverview() {
    return CustomExpansionTile(
      contentPadding: const EdgeInsets.all(16.0),
      decoration: getCustomExpansionTileDecoration(context),
      titleStyle: customExpansionTileTitleStyle,
      title: 'Overview',
      children: <Widget>[
        Text(
          details.overview,
          textAlign: TextAlign.justify,
          style: textTheme.body1,
        ),
      ],
    );
  } */

  Widget _buildGuestStars() {
    final TextStyle textStyle = textTheme.body2.copyWith(
      color: Colors.blue,
      decoration: TextDecoration.underline,
    );
    final Color iconColor = Colors.black.withOpacity(0.38);

    return CustomExpansionTile(
      contentPadding: const EdgeInsets.all(16.0),
      decoration: getCustomExpansionTileDecoration(context),
      titleStyle: customExpansionTileTitleStyle,
      title: 'Guest Stars',
      children: <Widget>[
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: details.guestStars.length,
          separatorBuilder: (context, index) => const SizedBox(height: 4.0),
          itemBuilder: (context, index) {
            final TvEpisodeGuestStar guestStar = details.guestStars.elementAt(index);

            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PersonDetailsPage(guestStar.id),
                ));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.chevron_right, color: iconColor, size: 22.0),
                  Expanded(
                    child: Text(
                      guestStar.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  MediaDetailsSliverDelegate buildHeaderDelegate() {
    return MediaDetailsSliverDelegate(
      mediaItem: mediaItem,
      favoritesBloc: favoritesBloc,
      title: widget.tv.name,
      subtitle: 'Season: ${widget.tvSeason.seasonNumber.toString().padLeft(2, '0')} - '
          'Episode: ${widget.episodeNumber.toString().padLeft(2, '0')}',
      bottomText: mediaItem?.dateTime?.year?.toString() ?? '',
      favoritable: false,
    );
  }

  @override
  TmdbMediaItem buildMediaItem() {
    return TmdbMediaItem(
      id: details.id,
      name: details.name,
      description: details.overview,
      dateTime: details.airDate,
      imageUrl: details.getStillUrl(),
      homepage: null,
      mediaType: TmdbMediaType.tv,
    );
  }

  @override
  List<Widget> buildPageContent() {
    return <Widget>[]
      ..addAll(
        [
          buildVoteAverage(details.voteAverage),
          vertSpacer(),
        ],
      )
      ..addAll(
        details.overview != null && details.overview.isNotEmpty
            ? [
                _buildOverview(),
                vertSpacer(),
              ]
            : [],
      )
      ..addAll(
        details.guestStars != null && details.guestStars.isNotEmpty
            ? [
                _buildGuestStars(),
                vertSpacer(),
              ]
            : [],
      );
  }

  @override
  Future<TvEpisode> getDetails() async {
    return ApiTv()
        .tvEpisodeDetails(widget.tv.id, widget.tvSeason.seasonNumber, widget.episodeNumber)
        .then((details) => details);
  }

  @override
  Widget voteAverageLeftWidget() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text('Season:', style: textTheme.subtitle),
              Text('Episode:', style: textTheme.subtitle),
            ],
          ),
        ),
        const SizedBox(width: 4.0),
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.tvSeason.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.body1,
              ),
              Text(
                details.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.body1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
