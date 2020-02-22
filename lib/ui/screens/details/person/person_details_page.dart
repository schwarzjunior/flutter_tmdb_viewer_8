import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdb_viewer_8/global/app_defaults.dart';
import 'package:tmdb_viewer_8/helpers/tmdb_helpers.dart';
import 'package:tmdb_viewer_8/models/tmdb_media_item.dart';
import 'package:tmdb_viewer_8/ui/common/widgets/custom_expansio_tile.dart';
import 'package:tmdb_viewer_8/ui/screens/details/base/delegates/media_details_sliver_delegate.dart';
import 'package:tmdb_viewer_8/ui/screens/details/base/media_details_page_mixin.dart';
import 'package:tmdb_viewer_8/ui/screens/details/person/widgets/credit_card.dart';

class PersonDetailsPage extends StatefulWidget {
  const PersonDetailsPage(this.id, {Key key}) : super(key: key);

  final int id;

  @override
  _PersonDetailsPageState createState() => _PersonDetailsPageState();
}

class _PersonDetailsPageState extends State<PersonDetailsPage>
    with MediaDetailsPageMixin<People, PersonDetailsPage>, TmdbHelpersMixin {
  String get _personAgeInfo {
    if (details.birthday == null) return null;

    String info = formatDate(details.birthday);
    if (details.deathday == null)
      info += '  (${calculatePersonAge(details.birthday)}) years';
    else
      info += '  ─  ${formatDate(details.deathday)}';

    return info;
  }

  Widget _buildBiography() {
    if ((details?.biography ?? '').isEmpty) return null;

    return CustomExpansionTile(
      contentPadding: const EdgeInsets.all(16.0),
      decoration: getCustomExpansionTileDecoration(context),
      title: 'Biography',
      titleStyle: customExpansionTileTitleStyle,
      children: <Widget>[
        Text(
          details.biography,
          textAlign: TextAlign.justify,
          style: textTheme.body1,
        ),
      ],
    );
  }

  List<Widget> _buildCredits() {
    if (details.credits == null || details.credits.isEmpty) return [];

    final int biggestIndex = 30.clamp(0, details.credits.length);

    List<Widget> items = details.credits.getRange(0, biggestIndex).map((PeopleCredit credit) {
      return CreditCard(credit);
    }).toList();

    return <Widget>[
      vertSpacer(),
      Padding(
        padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
        child: Text(
          'Credits',
          style: textTheme.subhead.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      CustomScrollView(
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
      ),
    ];
  }

  @override
  MediaDetailsSliverDelegate buildHeaderDelegate() {
    return MediaDetailsSliverDelegate(
      mediaItem: mediaItem,
      favoritesBloc: favoritesBloc,
      title: mediaItem.name,
      bottomText: _personAgeInfo,
    );
  }

  @override
  TmdbMediaItem buildMediaItem() {
    return TmdbMediaItem(
      id: details.id,
      name: details.name,
      description: details.biography,
      dateTime: details.birthday,
      imageUrl: details.getProfileUrl(),
      homepage: details.homepage,
      mediaType: TmdbMediaType.person,
    );
  }

  @override
  List<Widget> buildPageContent() {
    final List<Widget> items = <Widget>[]
      ..addAll([
        buildVoteAverage(details.popularity),
        divider(),
      ])
      ..addAll([
        infoLine('Place of birth:', details.placeOfBirth, errorText: 'Não disponível'),
        divider(),
      ])
      ..addAll([
        _buildBiography(),
      ])
      ..addAll(
        _buildCredits(),
      );

    return items;
  }

  @override
  Future<People> getDetails() async {
    return ApiPeople().peopleDetails(widget.id).then((details) => details);
  }

  @override
  Widget voteAverageLeftWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Known for:', style: textTheme.title.copyWith(fontSize: 16.0)),
        const SizedBox(height: 2.0),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            details.knownForDepartment,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
