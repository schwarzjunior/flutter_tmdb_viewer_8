import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdb_viewer_8/global/app_defaults.dart';
import 'package:tmdb_viewer_8/helpers/tmdb_helpers.dart';
import 'package:tmdb_viewer_8/models/tmdb_media_item.dart';
import 'package:tmdb_viewer_8/ui/common/widgets/custom_expansio_tile.dart';
import 'package:tmdb_viewer_8/ui/screens/details/base/delegates/media_details_sliver_delegate.dart';
import 'package:tmdb_viewer_8/ui/screens/details/base/media_details_page_mixin.dart';
import 'package:tmdb_viewer_8/ui/screens/details/tv/tv_episode_details_page.dart';

class TvSeasonDetailsPage extends StatefulWidget {
  const TvSeasonDetailsPage(this.tv, this.seasonNumber, {Key key}) : super(key: key);

  final Tv tv;
  final int seasonNumber;

  @override
  _TvSeasonDetailsPageState createState() => _TvSeasonDetailsPageState();
}

class _TvSeasonDetailsPageState extends State<TvSeasonDetailsPage>
    with MediaDetailsPageMixin<TvSeason, TvSeasonDetailsPage>, TmdbHelpersMixin {
  Widget _buildOverview() {
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
  }

  Widget _buildEpisodes() {
    final TextStyle textStyle = textTheme.body2.copyWith(
      color: Colors.blue,
      decoration: TextDecoration.underline,
    );
    final Color iconColor = Colors.black.withOpacity(0.38);

    return CustomExpansionTile(
      contentPadding: const EdgeInsets.all(16.0),
      decoration: getCustomExpansionTileDecoration(context),
      titleStyle: customExpansionTileTitleStyle,
      title: 'Episodes',
      children: <Widget>[
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: details.episodes.length,
          separatorBuilder: (context, index) => const SizedBox(height: 4.0),
          itemBuilder: (context, index) {
            final TvEpisode episode = details.episodes.elementAt(index);

            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      TvEpisodeDetailsPage(widget.tv, details, episode.episodeNumber),
                ));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.chevron_right, color: iconColor, size: 22.0),
                  Expanded(
                    child: Text(
                      '${episode.episodeNumber.toString().padLeft(2, '0')} - ${episode.name}',
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
      subtitle: 'Season: ${widget.seasonNumber.toString().padLeft(2, '0')}',
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
      imageUrl: details.getPosterUrl(),
      homepage: null,
      mediaType: TmdbMediaType.tv,
    );
  }

  @override
  List<Widget> buildPageContent() {
    return <Widget>[]
      ..addAll(
        [
          buildVoteAverage(0),
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
        [
          _buildEpisodes(),
        ],
      );
  }

  @override
  Future<TvSeason> getDetails() async {
    return ApiTv()
        .tvSeasonDetails(widget.tv.id, widget.seasonNumber)
        .then((details) => details);
  }

  @override
  Widget voteAverageLeftWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Season:',
              textAlign: TextAlign.end,
              style: textTheme.body1.copyWith(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4.0),
            Expanded(
              child: Text(
                details.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: textTheme.body1.copyWith(fontSize: 14.0),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              details.episodes.length.toString().padLeft(2, '0'),
              style: textTheme.body1.copyWith(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4.0),
            Text(
              'episodes',
              style: textTheme.body1.copyWith(fontSize: 15.0),
            ),
          ],
        ),
      ],
    );
  }
}
