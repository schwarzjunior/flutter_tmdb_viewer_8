import 'package:flutter/material.dart';
import 'package:tmdb_viewer_8/ui/common/widgets/circular_icon_button.dart';

class FavoriteTogglerButton extends CircularIconButton {
  FavoriteTogglerButton({
    Key key,
    @required this.status,
    @required VoidCallback onTap,
    EdgeInsetsGeometry padding,
    CircularIconButtonSize size = const CircularIconButtonSize(sizeType: CircularIconButtonSizeType.toolbar),
    AlignmentGeometry alignment = const Alignment(0, 0),
    Color iconColor = Colors.yellow,
    Color backgroundColor = Colors.black,
    double opacity = 0.1,
    Color splashColor,
    double borderWidth = 0.0,
    Color borderColor = Colors.black,
    String tooltip,
  }) : super(Icon(status ? Icons.star : Icons.star_border, color: iconColor),
            key: key,
            onTap: onTap,
            padding: padding,
            size: size,
            alignment: alignment,
            backgroundColor: backgroundColor,
            opacity: opacity,
            splashColor: splashColor,
            borderWidth: borderWidth,
            borderColor: borderColor,
            tooltip: tooltip ?? (status ? 'Remove favorite' : 'Add favorite'));

  final bool status;

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }
}
