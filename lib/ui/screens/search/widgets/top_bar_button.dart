import 'package:flutter/material.dart';

class TopBarButton extends StatelessWidget {
  const TopBarButton({
    Key key,
    this.label,
    this.labelColor,
    this.decoration,
    this.onPressed,
  }) : super(key: key);

  final String label;
  final Color labelColor;
  final BoxDecoration decoration;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final Color _labelColor = labelColor ?? Theme.of(context).unselectedWidgetColor;

    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 40.0,
          alignment: const Alignment(0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          decoration: decoration,
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _labelColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
