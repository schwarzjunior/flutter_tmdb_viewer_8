import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_sch_widgets/flutter_sch_widgets.dart';
import 'package:tmdb_viewer_8/ui/common/widgets/custom_expansio_tile.dart';

const TextStyle customExpansionTileTitleStyle = const TextStyle(
  inherit: true,
  letterSpacing: 0.4,
  fontWeight: FontWeight.w400,
);

const CustomExpansionTileDecoration _customExpansionTileDecorationLight =
    const CustomExpansionTileDecoration(
  collapsedBorderColor: const Color(0xdd000000),
  collapsedHeaderColor: const Color(0x00000000),
  expandedHeaderColor: const Color(0xffe0e0e0),
  collapsedTitleColor: const Color(0xff616161),
  expandedTitleColor: Color(0xff303030), // 424242 (lighter)
  collapsedIconColor: const Color(0x61000000),
  expandedIconColor: const Color(0x8a000000),
  collapsedBodyColor: const Color(0xffe0e0e0),
  expandedBodyColor: const Color(0xfff5f5f5), // eeeeee (darker)
  borderWidth: 0.4,
  dividerThickness: 0.3,
);

const CustomExpansionTileDecoration _customExpansionTileDecorationDark =
    const CustomExpansionTileDecoration(
  collapsedBorderColor: const Color(0xffe0e0e0),
  collapsedHeaderColor: const Color(0x61000000),
  expandedHeaderColor: const Color(0xff000000),
  collapsedBodyColor: const Color(0xffe0e0e0),
  expandedBodyColor: const Color(0xff424242),
  collapsedTitleColor: const Color(0xffbdbdbd),
  expandedTitleColor: const Color(0xffeeeeee),
  expandedIconColor: const Color(0xffe0e0e0),
  borderWidth: 0.4,
  dividerThickness: 0.3,
);

///
/// Retorna o [CustomExpansionTileDecoration] de acordo com o modo do tema atual.
///
CustomExpansionTileDecoration getCustomExpansionTileDecoration(BuildContext context) {
  return MediaQuery.of(context).platformBrightness == Brightness.light
      ? _customExpansionTileDecorationLight
      : _customExpansionTileDecorationDark;
}
