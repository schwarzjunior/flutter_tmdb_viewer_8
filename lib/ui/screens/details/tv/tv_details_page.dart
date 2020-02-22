import 'package:flutter/material.dart';
import 'package:flutter_sch_widgets/flutter_sch_widgets.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdb_viewer_8/global/app_defaults.dart';
import 'package:tmdb_viewer_8/helpers/tmdb_helpers.dart';
import 'package:tmdb_viewer_8/models/tmdb_media_item.dart';
import 'package:tmdb_viewer_8/ui/common/widgets/custom_expansio_tile.dart';
import 'package:tmdb_viewer_8/ui/screens/details/base/delegates/media_details_sliver_delegate.dart';
import 'package:tmdb_viewer_8/ui/screens/details/base/media_details_page_mixin.dart';

class TvDetailsPage extends StatefulWidget {
  const TvDetailsPage(this.id, {Key key}) : super(key: key);

  final int id;

  @override
  _TvDetailsPageState createState() => _TvDetailsPageState();
}

class _TvDetailsPageState extends State<TvDetailsPage>
    with MediaDetailsPageMixin<Tv, TvDetailsPage> {
  Widget _buildOverview() {
    return CustomExpansionTile(
      contentPadding: const EdgeInsets.all(16.0),
      decoration: getCustomExpansionTileDecoration(context),
      title: 'Overview',
      titleStyle: customExpansionTileTitleStyle,
      children: <Widget>[
        Text(
          details.overview,
          textAlign: TextAlign.justify,
          style: textTheme.body1,
        ),
      ],
    );
  }

  Widget _buildCreatedBy() {
    final TextStyle textStyle = textTheme.body2.copyWith(
      color: Colors.blue,
      decoration: TextDecoration.underline,
    );
    final Color iconColor = Colors.black.withOpacity(0.38);

    return CustomExpansionTile(
      contentPadding: const EdgeInsets.all(16.0),
      decoration: getCustomExpansionTileDecoration(context),
      title: 'Created By',
      titleStyle: customExpansionTileTitleStyle,
      children: <Widget>[
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: details.createdBy.length,
          separatorBuilder: (context, index) => SizedBox(height: 4.0),
          itemBuilder: (context, index) {
            final TvCreatedBy createdBy = details.createdBy.elementAt(index);

            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Container(),
                ));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.chevron_right, color: iconColor, size: 22.0),
                  Expanded(
                    child: Text(
                      createdBy.name,
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

  Widget _buildSeasons() {
    final TextStyle textStyle =
        textTheme.subtitle.copyWith(color: Colors.black.withOpacity(0.68));
    final Color iconColor = Colors.black.withOpacity(0.38);

    return CustomExpansionTile(
      contentPadding: const EdgeInsets.all(16.0),
      decoration: getCustomExpansionTileDecoration(context),
      title: 'Seasons',
      titleStyle: customExpansionTileTitleStyle,
      children: <Widget>[
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: details.seasons.length,
          separatorBuilder: (context, index) => const SizedBox(height: 4.0),
          itemBuilder: (context, index) {
            final TvSeasonResumed season = details.seasons.elementAt(index);

            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Container(),
                ));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.chevron_right, color: iconColor, size: 22.0),
                  Expanded(
                    child: Text(
                      '${season.seasonNumber.toString().padLeft(2, '0')} - ${season.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle.copyWith(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
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

  Widget _buildVideosList() {
    return CustomExpansionTile(
      contentPadding: const EdgeInsets.all(16.0),
      // decoration: getCustomExpansionTileDecoration(Theme.of(context).brightness),
      decoration: getCustomExpansionTileDecoration(context),
      title: 'Videos',
      titleStyle: customExpansionTileTitleStyle,
      children: <Widget>[
        _TvVideosList(
          videos: details.videos,
          includeHeader: false,
        ),
      ],
    );
  }

  @override
  MediaDetailsSliverDelegate buildHeaderDelegate() {
    return MediaDetailsSliverDelegate(
      mediaItem: mediaItem,
      favoritesBloc: favoritesBloc,
      title: mediaItem.name,
      bottomText: mediaItem?.dateTime?.year?.toString() ?? '',
    );
  }

  @override
  TmdbMediaItem buildMediaItem() {
    return TmdbMediaItem(
      id: details.id,
      name: details.name,
      description: details.overview,
      dateTime: details.firstAirDate,
      imageUrl: details.getBackdropUrl() ?? details.getPosterUrl(),
      homepage: details.homepage,
      mediaType: TmdbMediaType.tv,
    );
  }

  @override
  List<Widget> buildPageContent() {
    return <Widget>[
      buildVoteAverage(details.voteAverage),
      vertSpacer(),
      _buildOverview(),
      vertSpacer(),
      infoLine('Status:', details.status),
      vertSpacer(),
      infoLine('In production:', details.inProduction ? 'Yes' : 'No'),
      vertSpacer(),
      _buildCreatedBy(),
      vertSpacer(),
      _buildSeasons(),
      vertSpacer(),
      _buildVideosList(),
    ];
  }

  @override
  Future<Tv> getDetails() async {
    return ApiTv().tvDetails(widget.id).then((details) => details);
  }

  @override
  Widget voteAverageLeftWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              details.numberOfSeasons.toString().padLeft(2, '0'),
              style: textTheme.body1.copyWith(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4.0),
            Text(
              'seasons',
              style: textTheme.body1.copyWith(fontSize: 15.0),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text(
              details.numberOfEpisodes.toString().padLeft(2, '0'),
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

class _TvVideosList extends StatelessWidget with TmdbHelpersMixin {
  const _TvVideosList({Key key, this.videos, this.includeHeader = true}) : super(key: key);

  final List<TvVideo> videos;
  final bool includeHeader;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.body2.copyWith(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        );
    final Color iconColor = Colors.black.withOpacity(0.38);

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: videos.length,
      separatorBuilder: (context, index) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        final TvVideo video = videos.elementAt(index);

        return InkWell(
          onTap: () {
            openUrl(video.youtubeVideoUrl);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.chevron_right, color: iconColor, size: 22),
              Expanded(
                child: Text(
                  video.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
