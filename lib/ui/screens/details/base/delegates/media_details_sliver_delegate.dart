import 'package:flutter/material.dart';
import 'package:tmdb_viewer_8/blocs/favorites/favorites_bloc.dart';
import 'package:tmdb_viewer_8/helpers/tmdb_helpers.dart';
import 'package:tmdb_viewer_8/models/tmdb_media_item.dart';
import 'package:tmdb_viewer_8/ui/common/custom_widgets.dart';

part 'media_icon_card.part.dart';

const double _defaultExpandedHeight = 200.0;
const double _mediaIconCardSize = 50.0;
const double _opacityFactor = _mediaIconCardSize / 2.0;
const double _defaultIconSize = 24.0;
const double _iconSizeFactor = _defaultIconSize / _mediaIconCardSize;

class MediaDetailsSliverDelegate extends SliverPersistentHeaderDelegate with TmdbHelpersMixin {
  MediaDetailsSliverDelegate({
    this.expandedHeight = _defaultExpandedHeight,
    @required this.favoritesBloc,
    @required this.mediaItem,
    @required this.title,
    this.subtitle,
    this.bottomText,
    this.centerTitle = true,
    this.favoritable = true,
  })  : assert(expandedHeight != null),
        assert(favoritesBloc != null);

  final double expandedHeight;
  final FavoritesBloc favoritesBloc;
  final TmdbMediaItem mediaItem;
  final String title;
  final String subtitle;
  final String bottomText;
  final bool centerTitle;
  final bool favoritable;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: <Widget>[
          _makeBackgroundPoster(context, shrinkOffset),
          _makeBottomText(context, shrinkOffset),
          _makeTopAppBar(context),
          _makeFavoriteTogglerButton(),
          _makeFloatingMediaIconCard(context, shrinkOffset),
        ],
      ),
    );
  }

  Widget _makeBackgroundPoster(BuildContext context, double shrinkOffset) {
    const Color shadowColor = Color(0xff212121);

    final Color backgroundColor =
        mediaItem.imageUrl != null ? Colors.black.withOpacity(0.4) : Colors.transparent;
    final Widget backgroundWidget = mediaItem.imageUrl != null
        ? Opacity(
            opacity: _clampDouble(1.0 - (shrinkOffset / ((expandedHeight * 2.0) - kToolbarHeight))),
            child: Image.network(mediaItem.imageUrl, fit: BoxFit.cover),
          )
        : Container(
            color: Colors.black.withOpacity(0.5),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double cardSize = constraints.smallest.height / 2.5;
                final double opacity =
                    _clampDouble(1.0 - (shrinkOffset / (expandedHeight - (kToolbarHeight * 2.0))));

                return Center(
                  child: _MediaIconCard(
                    getMediaTypeIcon(mediaItem.mediaType),
                    size: cardSize,
                    elevation: 4.0,
                    opacity: opacity,
                    backgroundColor: Colors.grey.withAlpha(90),
                  ),
                );
              },
            ),
          );

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: <BoxShadow>[
          const BoxShadow(
            offset: const Offset(0, 1.5),
            color: shadowColor,
            blurRadius: 20.0,
          ),
        ],
      ),
      child: backgroundWidget,
    );
  }

  Widget _makeTopAppBar(BuildContext context) {
    List<Widget> appBarTitleChildren = <Widget>[
      Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: centerTitle ? TextAlign.center : TextAlign.start,
        style: _mergeTextStyle(Theme.of(context).primaryTextTheme.title),
      ),
    ];
    if (subtitle != null && subtitle.isNotEmpty) {
      appBarTitleChildren.add(
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: centerTitle ? TextAlign.center : TextAlign.start,
          style: _mergeTextStyle(
            Theme.of(context).primaryTextTheme.subtitle,
            shadowOffset: 1.5,
          ),
        ),
      );
    }

    return Positioned(
      top: 0,
      left: 0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularIconButton(
            BackButton(color: Theme.of(context).primaryTextTheme.button.color),
            onTap: () {
              if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            },
            size: const CircularIconButtonSize(sizeType: CircularIconButtonSizeType.toolbar),
            opacity: 0.15,
            backgroundColor: Colors.black,
          ),
          Container(
            width: MediaQuery.of(context).size.width - (kToolbarHeight * 2.0),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(children: appBarTitleChildren),
          ),
        ],
      ),
    );
  }

  Widget _makeBottomText(BuildContext context, double shrinkOffset) {
    if (bottomText == null || bottomText.isEmpty) return Container();

    final double opacity =
        _clampDouble(1.0 - (shrinkOffset / (expandedHeight - kToolbarHeight - _opacityFactor)));

    return Positioned(
      bottom: 0,
      left: 0,
      child: Container(
        width: MediaQuery.of(context).size.width - kToolbarHeight,
        padding: const EdgeInsets.all(10.0),
        child: Opacity(
          opacity: opacity,
          child: Text(
            bottomText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _mergeTextStyle(
              Theme.of(context).textTheme.headline,
              color: Colors.white.withAlpha(210),
              shadowColor: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _makeFavoriteTogglerButton() {
    return favoritable
        ? Positioned(
            bottom: 0,
            right: 0,
            child: StreamBuilder<List<TmdbMediaItem>>(
              stream: favoritesBloc.outFavorites,
              initialData: favoritesBloc.favoritesList,
              builder: (_, snapshot) {
                final bool isFavorite = favoritesBloc.checkIsFavorite(mediaItem);

                return FavoriteTogglerButton(
                  onTap: () => favoritesBloc.toggleFavorite(mediaItem),
                  status: isFavorite,
                  opacity: 0.15,
                );
              },
            ),
          )
        : Container();
  }

  Widget _makeFloatingMediaIconCard(BuildContext context, double shrinkOffset) {
    final double halfCardSize = _mediaIconCardSize / 2.0;
    final double top = expandedHeight - halfCardSize - shrinkOffset;
    final double left = (MediaQuery.of(context).size.width / 2.0) - halfCardSize;
    final double opacity =
        _clampDouble(1.0 - (shrinkOffset / (expandedHeight - kToolbarHeight - _opacityFactor)));

    return Positioned(
      top: top,
      left: left,
      child: _MediaIconCard(getMediaTypeIcon(mediaItem.mediaType), opacity: opacity),
    );
  }

  TextStyle _mergeTextStyle(
    TextStyle textStyle, {
    Color color,
    double letterSpacing = 0.5,
    double shadowOffset = 2.0,
    double shadowBlurRadius = 5.0,
    Color shadowColor = Colors.black,
  }) {
    return textStyle.merge(TextStyle(
      inherit: true,
      color: color,
      letterSpacing: letterSpacing,
      shadows: <Shadow>[
        Shadow(
          offset: Offset(shadowOffset, shadowOffset),
          color: shadowColor,
          blurRadius: shadowBlurRadius,
        ),
      ],
    ));
  }

  double _clampDouble(double value) => value.clamp(0.0, 1.0);

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
