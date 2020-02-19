import 'package:flutter/material.dart';

class BottomAppBarButton extends StatelessWidget {
  const BottomAppBarButton({
    Key key,
    this.iconData,
    this.label,
    this.highlighted,
    this.onPressed,
  }) : super(key: key);

  final IconData iconData;
  final String label;
  final bool highlighted;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final bool darkMode = Theme.of(context).brightness == Brightness.dark;
    final Color color = darkMode ? Colors.white : Colors.black;
    final Color highlightColor = darkMode ? Colors.lightBlue[400] : Colors.lightBlue;

    return Container(
      width: 100.0,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                iconData,
                size: 20.0,
                color: highlighted ? highlightColor : color,
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.0,
                  color: highlighted ? highlightColor : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
