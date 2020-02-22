import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_viewer_8/blocs/favorites/favorites_bloc.dart';
import 'package:tmdb_viewer_8/models/tmdb_media_item.dart';
import 'package:tmdb_viewer_8/ui/screens/details/base/delegates/media_details_sliver_delegate.dart';

const double _vertSpacerHeight = 26.0;
const double _dividerHeight = _vertSpacerHeight * 1.4;

mixin MediaDetailsPageMixin<V, T extends StatefulWidget> on State<T> {
  V _details;
  TmdbMediaItem _mediaItem;
  TextTheme _textTheme;
  FavoritesBloc _favoritesBloc;

  V get details => this._details;

  TmdbMediaItem get mediaItem => this._mediaItem;

  TextTheme get textTheme => this._textTheme;

  FavoritesBloc get favoritesBloc => this._favoritesBloc;

  @override
  void didChangeDependencies() {
    this._favoritesBloc ??= Provider.of<FavoritesBloc>(context);
    this._textTheme = Theme.of(context).textTheme;
    super.didChangeDependencies();
  }

  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    return this.mainPage();
  }

  Widget mainPage() {
    return FutureBuilder<V>(
      future: this.getDetails(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Material(child: const Center(child: const CircularProgressIndicator()));
        }

        this._details = snapshot.data;
        this._mediaItem = this.buildMediaItem();

        final List<Widget> slivers = <Widget>[
          SliverPersistentHeader(
            delegate: this.buildHeaderDelegate(),
            pinned: true,
            floating: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(this._filterPageContent),
            ),
          ),
        ];

        return SafeArea(
          child: Material(
            child: Scaffold(
              body: CustomScrollView(
                slivers: slivers,
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> get _filterPageContent {
    return this.buildPageContent()..removeWhere((Widget child) => child is! Widget);
  }

  Widget buildVoteAverage(double voteAverage) {
    final int vaValue = (voteAverage * 10).toInt();
    final String vaText = vaValue == 0 ? 'ND' : vaValue.toString().padLeft(vaValue < 10 ? 2 : 3, ' ');
    final Color vaColor = vaValue == 0
        ? Colors.grey
        : (vaValue >= 70 ? Colors.lightGreenAccent[700] : Colors.yellowAccent[400]);

    return Container(
      height: 65.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
      child: Row(
        children: <Widget>[
          Expanded(child: this.voteAverageLeftWidget()),
          Container(
            width: 65.0,
            height: 65.0,
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              border: Border.all(color: vaColor, width: 5.0),
              borderRadius: const BorderRadius.all(const Radius.circular(32.5)),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(vaText,
                      style: this._textTheme.title.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                  Text(vaValue == 0 ? '' : '%',
                      style: this._textTheme.body2.copyWith(
                            color: this._textTheme.title.color,
                            fontSize: 12.0,
                          )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget infoLine(String label, String text, {String errorText, bool errorTextItalic = true}) {
    if ((text == null || text.isEmpty) && errorText == null) return null;

    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(label, style: this._textTheme.subhead),
        ),
        Expanded(
          child: Text(
            text ?? errorText,
            style: this._textTheme.subhead.copyWith(
                  color: this._textTheme.body2.color,
                  fontStyle: text == null && errorTextItalic ? FontStyle.italic : FontStyle.normal,
                ),
          ),
        ),
      ],
    );
  }

  Widget vertSpacer([double height]) => SizedBox(height: height ?? _vertSpacerHeight);

  Widget divider([double height, double thickness = 1.0]) =>
      Divider(height: height ?? _dividerHeight, thickness: thickness);

  TmdbMediaItem buildMediaItem();

  Future<V> getDetails();

  Widget voteAverageLeftWidget();

  List<Widget> buildPageContent();

  MediaDetailsSliverDelegate buildHeaderDelegate();
}
