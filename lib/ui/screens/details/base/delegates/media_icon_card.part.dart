part of 'media_details_sliver_delegate.dart';

class _MediaIconCard extends StatelessWidget {
  const _MediaIconCard(
    this.iconData, {
    Key key,
    this.opacity = 1.0,
    this.size = _mediaIconCardSize,
    this.elevation = 10.0,
    this.backgroundColor,
  })  : assert(iconData != null),
        assert(opacity != null && opacity >= 0.0 && opacity <= 1.0),
        super(key: key);

  final IconData iconData;
  final double opacity;
  final double size;
  final double elevation;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final double iconSize = size * _iconSizeFactor;

    return Opacity(
      opacity: opacity,
      child: Card(
        margin: const EdgeInsets.all(0.0),
        color: backgroundColor ?? Colors.white.withOpacity(0.45),
        elevation: elevation,
        child: SizedBox(
          height: size,
          width: size,
          child: Icon(
            iconData,
            size: iconSize,
            color: Colors.black.withOpacity(0.60),
          ),
        ),
      ),
    );
  }
}
