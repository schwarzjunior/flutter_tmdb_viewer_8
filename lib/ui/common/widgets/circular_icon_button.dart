import 'package:flutter/material.dart';

const double _kDefaultSize = 56.0;
const double _kSmallSize = 40.0;
const double _kToolbarSize = kTextTabBarHeight;
const double _kToolbarPadding = (kToolbarHeight - kTextTabBarHeight) / 2.0;

enum CircularIconButtonSizeType {
  normal,
  small,
  toolbar,
}

@immutable
class CircularIconButtonSize {
  const CircularIconButtonSize({CircularIconButtonSizeType sizeType = CircularIconButtonSizeType.normal})
      : assert(sizeType != null),
        this.sizeType = sizeType,
        this._size = null;

  const CircularIconButtonSize.custom(double size)
      : assert(size != null),
        this.sizeType = null,
        this._size = size;

  final CircularIconButtonSizeType sizeType;
  final double _size;

  double get size {
    if (_size != null) return _size;
    switch (sizeType) {
      case CircularIconButtonSizeType.small:
        return _kSmallSize;
      case CircularIconButtonSizeType.toolbar:
        return _kToolbarSize;
      case CircularIconButtonSizeType.normal:
      default:
        return _kDefaultSize;
    }
  }
}

class CircularIconButton extends StatelessWidget {
  const CircularIconButton(
    this.child, {
    Key key,
    @required this.onTap,
    this.padding,
    this.size = const CircularIconButtonSize(sizeType: CircularIconButtonSizeType.normal),
    this.alignment = const Alignment(0, 0),
    this.backgroundColor,
    this.opacity = 0.5,
    this.splashColor,
    this.borderWidth = 0.0,
    this.borderColor = Colors.black,
    this.tooltip,
  })  : assert(child != null),
        assert(size != null),
        assert(alignment != null),
        assert(opacity != null),
        assert(borderWidth != null),
        assert(borderColor != null),
        super(key: key);

  final VoidCallback onTap;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final CircularIconButtonSize size;
  final AlignmentGeometry alignment;
  final Color backgroundColor;
  final double opacity;
  final Color splashColor;
  final double borderWidth;
  final Color borderColor;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final Color _backgroundColor =
        (backgroundColor ?? Theme.of(context).buttonTheme.colorScheme.primary).withOpacity(opacity);
    final EdgeInsetsGeometry _padding = padding ??
        EdgeInsets.all((size.sizeType == CircularIconButtonSizeType.toolbar ? _kToolbarPadding : 0.0));
    final Color _splashColor = splashColor ?? Theme.of(context).splashColor;
    final Color _borderColor = borderWidth > 0.0 ? borderColor : Colors.transparent;

    return Container(
      width: size.size,
      height: size.size,
      margin: _padding,
      alignment: alignment,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: ClipOval(
          child: Material(
            color: _backgroundColor,
            child: InkWell(
              onTap: onTap,
              splashColor: _splashColor,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(
                    width: borderWidth,
                    color: _borderColor,
                  ),
                ),
                child: tooltip != null && tooltip.isNotEmpty
                    ? Tooltip(
                        excludeFromSemantics: true,
                        message: tooltip,
                        child: child,
                      )
                    : child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
