import 'package:flutter/material.dart' show required, IconData;
import 'package:tmdb_api/tmdb_api.dart' show TmdbTrendingMediaType;

class TrendingTabItem {
  const TrendingTabItem({
    @required this.title,
    @required this.iconData,
    @required this.mediaType,
  });

  final String title;
  final IconData iconData;
  final TmdbTrendingMediaType mediaType;
}
