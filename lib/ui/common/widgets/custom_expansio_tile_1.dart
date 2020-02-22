import 'package:flutter/material.dart';

const Duration _kExpand = const Duration(milliseconds: 200);

/// A single-line [ListTile] with a trailing button that expands or collapses
/// the tile to reveal or hide the [body].
///
/// This widget is typically used with [ListView] to create an
/// "expand / collapse" list entry. When used with scrolling widgets like
/// [ListView], a unique [PageStorageKey] must be specified to enable the
/// [CustomExpansionTile] to save and restore its expanded state when it is scrolled
/// in and out of view.
///
/// See also:
///
///  * [ListTile], useful for creating expansion tile [children] when the
///    expansion tile represents a sublist.
///  * The "Expand/collapse" section of
///    <https://material.io/guidelines/components/lists-controls.html>.
class CustomExpansionTile extends StatefulWidget {
  const CustomExpansionTile({
    Key key,
    this.leading,
    @required this.title,
    this.body,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.headerPadding = const EdgeInsets.symmetric(horizontal: 8.0),
    this.contentPadding = const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
    this.trailingIcon = Icons.expand_more,
    this.trailingRotation = true,
    this.decoration = const CustomExpansionTileDecoration(),
  })  : assert(initiallyExpanded != null),
        assert(headerPadding != null),
        assert(contentPadding != null),
        assert(trailingIcon != null),
        assert(trailingRotation != null),
        super(key: key);

  /// A widget to display before the tile.
  ///
  /// Typically a [CircleAvatar] widget.
  final Widget leading;

  /// The title of the tile.
  final String title;

  /// The widget that is displayed when the tile expands.
  ///
  /// Tipically [ListTile] widgets.
  final Widget body;

  /// Specifies if the list tile is initially expanded (true) or collapsed (false, the default).
  final bool initiallyExpanded;

  /// Called when the tile expands or collapses.
  ///
  /// When the tile starts expanding, this function is called with the value
  /// true. When the tile starts collapsing, this function is called with
  /// the value false.
  final ValueChanged<bool> onExpansionChanged;

  /// The padding of the tile header.
  final EdgeInsetsGeometry headerPadding;

  /// The padding of the tile's body.
  final EdgeInsetsGeometry contentPadding;

  /// The icon to display after the title.
  final IconData trailingIcon;

  /// If the trailing icon must rotate on expand.
  final bool trailingRotation;

  /// The decoration of [ListTile].
  final CustomExpansionTileDecoration decoration;

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween = CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _titleColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _bodyColorTween = ColorTween();

  AnimationController _controller;
  Animation<double> _iconTurns;
  Animation<double> _heightFactor;
  Animation<Color> _borderColor;
  Animation<Color> _headerColor;
  Animation<Color> _titleColor;
  Animation<Color> _iconColor;
  Animation<Color> _bodyColor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeOutTween));
    _titleColor = _controller.drive(_titleColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _bodyColor = _controller.drive(_bodyColorTween.chain(_easeOutTween));

    _isExpanded = PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _borderColorTween
      ..begin = widget?.decoration?.collapsedBorderColor ?? theme.dividerColor
      ..end = widget?.decoration?.expandedBorderColor ??
          widget?.decoration?.collapsedBorderColor ??
          theme.dividerColor;
    _headerColorTween
      ..begin = widget?.decoration?.collapsedHeaderColor ?? Colors.transparent
      ..end = widget?.decoration?.expandedHeaderColor ??
          widget?.decoration?.collapsedHeaderColor ??
          Colors.transparent;
    _titleColorTween
      ..begin = widget?.decoration?.collapsedTitleColor ?? theme.textTheme.subhead.color
      ..end = widget?.decoration?.expandedTitleColor ?? theme.accentColor;
    _iconColorTween
      ..begin = widget?.decoration?.collapsedIconColor ?? theme.unselectedWidgetColor
      ..end = widget?.decoration?.expandedIconColor ?? theme.accentColor;
    _bodyColorTween
      ..begin = widget?.decoration?.collapsedBodyColor ?? Colors.transparent
      ..end = widget?.decoration?.expandedBodyColor ??
          widget?.decoration?.collapsedBodyColor ??
          Colors.transparent;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildBody,
      child: closed
          ? null
          : Container(
              color: _bodyColor.value,
              child: Padding(
                padding: widget.contentPadding,
                child: widget.body,
              ),
            ),
    );
  }

  Widget _buildBody(BuildContext context, Widget child) {
    final Color borderSideColor = _borderColor.value ?? Colors.transparent;

    return Container(
      decoration: BoxDecoration(
        color: _headerColor.value ?? Colors.transparent,
        border: Border.fromBorderSide(
          BorderSide(color: borderSideColor, width: widget?.decoration?.borderWidth),
        ),
        borderRadius: BorderRadius.all(Radius.circular(widget?.decoration?.borderRadius)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTileTheme.merge(
            iconColor: _iconColor.value,
            textColor: _titleColor.value,
            child: ListTile(
              contentPadding: widget.headerPadding,
              onTap: _handleTap,
              leading: widget.leading,
              title: Text(widget.title,
                  style: widget?.decoration?.titleStyle?.merge(
                    TextStyle(color: _titleColor.value),
                  )),
              trailing: widget.trailingRotation
                  ? RotationTransition(
                      turns: _iconTurns,
                      child: Icon(widget.trailingIcon),
                    )
                  : Icon(widget.trailingIcon),
            ),
          ),
          _isExpanded
              ? Divider(
                  height: 0.0,
                  thickness:
                      widget?.decoration?.dividerThickness ?? widget?.decoration?.borderWidth,
                  color: borderSideColor ?? Colors.transparent,
                )
              : Container(),
          ClipRect(
            child: Align(
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.body
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
    if (widget.onExpansionChanged != null) widget.onExpansionChanged(_isExpanded);
  }
}

///
/// The decoration properties of a [CustomExpansionTile] widget.
///
class CustomExpansionTileDecoration {
  const CustomExpansionTileDecoration({
    this.collapsedBorderColor,
    this.expandedBorderColor,
    this.collapsedHeaderColor,
    this.expandedHeaderColor,
    this.collapsedTitleColor,
    this.expandedTitleColor,
    this.collapsedIconColor,
    this.expandedIconColor,
    this.collapsedBodyColor,
    this.expandedBodyColor,
    this.titleStyle,
    this.borderWidth = 0.0,
    this.borderRadius = 0.0,
    this.dividerThickness,
  })  : assert(borderWidth != null),
        assert(borderRadius != null);

  /// The final color of the border when collapsed.
  final Color collapsedBorderColor;

  /// The final color of the border when expanded.
  final Color expandedBorderColor;

  /// The final color of the header background when collapsed.
  final Color collapsedHeaderColor;

  /// The final color of the header background when expanded.
  final Color expandedHeaderColor;

  /// The final color of the title when collapsed.
  final Color collapsedTitleColor;

  /// The final color of the title when expanded.
  final Color expandedTitleColor;

  /// The final color of the icon when collapsed.
  final Color collapsedIconColor;

  /// The final color of the icon when expanded.
  final Color expandedIconColor;

  /// The final color of the body background when collapsed.
  final Color collapsedBodyColor;

  /// The final color of the body background when expanded.
  final Color expandedBodyColor;

  /// The style of the title text.
  final TextStyle titleStyle;

  /// The width of the border.
  final double borderWidth;

  /// The radius of the border.
  final double borderRadius;

  /// The thickness of the line drawn between the header and the body of the tile.
  ///
  /// if **null**, the [borderWidth] value will be used.
  final double dividerThickness;
}
