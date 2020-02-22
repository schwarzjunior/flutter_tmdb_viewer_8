import 'package:flutter/material.dart';
import 'package:flutter_sch_widgets/flutter_sch_widgets.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdb_viewer_8/global/app_defaults.dart';
import 'package:tmdb_viewer_8/helpers/tmdb_helpers.dart';
import 'package:tmdb_viewer_8/models/tmdb_media_item.dart';
import 'package:tmdb_viewer_8/ui/common/widgets/custom_expansio_tile.dart';
import 'package:tmdb_viewer_8/ui/screens/details/base/delegates/media_details_sliver_delegate.dart';
import 'package:tmdb_viewer_8/ui/screens/details/base/media_details_page_mixin.dart';
import 'package:tmdb_viewer_8/ui/screens/details/movie/widgets/movie_cast_card.dart';
import 'package:tmdb_viewer_8/ui/screens/details/movie/widgets/movie_crew_card.dart';

class Entry {
  Entry(this.title, [this.children = const <Widget>[]]);

  final String title;
  final List<Widget> children;
}

class MovieDetailsPage extends StatefulWidget {
  const MovieDetailsPage(this.id, {Key key}) : super(key: key);

  final int id;

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage>
    with MediaDetailsPageMixin<Movie, MovieDetailsPage> {
  Widget _buildOverview() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4.0, 16.0, 4.0, 0.0),
      child: Text(
        details.overview,
        textAlign: TextAlign.justify,
        style: textTheme.body1,
      ),
    );
  }

  Widget _buildVideosList(List<MovieVideo> videos) {
    return Padding(
      padding: const EdgeInsets.only(top: 26.0),
      child: CustomExpansionTile(
        contentPadding: const EdgeInsets.all(16.0),
        decoration: getCustomExpansionTileDecoration(context),
        title: 'Videos',
        titleStyle: customExpansionTileTitleStyle,
        children: <Widget>[
          _MovieVideosList(videos: videos, includeHeader: false),
        ],
      ),
    );
  }

  Widget _buildCast() {
    final List<MovieCast> cast = _filterList<MovieCast>(details.credits.cast);
    final int maxItemIndex = 30.clamp(0, cast.length);
    final List<Widget> items =
        cast.getRange(0, maxItemIndex).map((MovieCast cast) => MovieCastCard(cast)).toList();

    return CustomScrollView(
      shrinkWrap: true,
      primary: false,
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            height: 140.0,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 140.0,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                childAspectRatio: 12.0 / 16.0,
              ),
              itemBuilder: (context, index) {
                return Container(
                  alignment: const Alignment(0, 0),
                  child: items.elementAt(index),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCrew() {
    List<MovieCrew> crew = _filterList<MovieCrew>(details.credits.crew);
    final int maxItemIndex = 30.clamp(0, crew.length);
    List<Widget> items =
        crew.getRange(0, maxItemIndex).map((MovieCrew crew) => MovieCrewCard(crew)).toList();

    return CustomScrollView(
      shrinkWrap: true,
      primary: false,
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            height: 140.0,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 140.0,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                childAspectRatio: 12.0 / 16.0,
              ),
              itemBuilder: (context, index) {
                return Container(
                  alignment: const Alignment(0, 0),
                  child: items.elementAt(index),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  List<T> _filterList<T>(List<T> items) {
    List<T> result = <T>[];

    if (items is List<MovieCrew>) {
      List<MovieCrew> crewItems = items as List<MovieCrew>;
      items.cast<MovieCrew>().map((crew) => crew.id).toSet().forEach((id) {
        result.add(crewItems.firstWhere((item) => item.id == id) as T);
      });
    } else if (items is List<MovieCast>) {
      List<MovieCast> castItems = items as List<MovieCast>;
      items.cast<MovieCast>().map((cast) => cast.id).toSet().forEach((id) {
        result.add(castItems.firstWhere((item) => item.id == id) as T);
      });
    }
    return result;
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
      name: details.title,
      description: details.overview,
      dateTime: details.releaseDate,
      imageUrl: details.getBackdropUrl() ?? details.getPosterUrl(),
      homepage: details.homepage,
      mediaType: TmdbMediaType.movie,
    );
  }

  @override
  List<Widget> buildPageContent() {
    final List<Widget> items = <Widget>[]
      ..addAll([
        buildVoteAverage(details.voteAverage),
        _buildOverview(),
        divider(),
        infoLine('Status:', details.status),
      ])
      ..addAll(
        (details.budget != null && details.budget != 0)
            ? [
                vertSpacer(),
//          infoLine('Budget:', formatCurrency(details.budget)),
                infoLine('Budget:', details.budget.toString()),
              ]
            : [],
      )
      ..addAll(
        (details.credits != null && details.credits.cast.isNotEmpty)
            ? [
                divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
                  child: Text(
                    'Cast',
                    style: textTheme.subhead.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                _buildCast(),
              ]
            : [],
      )
      ..addAll(details.credits != null && details.credits.crew.isNotEmpty
          ? [
              divider(),
              Padding(
                padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
                child: Text(
                  'Crew',
                  style: textTheme.subhead.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              _buildCrew(),
            ]
          : [])
      ..addAll([
        _buildVideosList(details.videos),
      ]);

    return items;
  }

  @override
  Future<Movie> getDetails() async {
    return ApiMovie().movieDetails(widget.id).then((details) => details);
  }

  @override
  Widget voteAverageLeftWidget() {
    return Text(
      details.tagline,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: textTheme.subtitle.copyWith(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _MovieVideosList extends StatelessWidget with TmdbHelpersMixin {
  const _MovieVideosList({Key key, this.videos, this.includeHeader = true}) : super(key: key);

  final List<MovieVideo> videos;
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
        final MovieVideo video = videos.elementAt(index);

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
