import 'package:flutter/material.dart';

bool printed = false;
String txt;

class MediaTile extends StatelessWidget {
  const MediaTile({Key key, this.title, this.iconData}) : super(key: key);

  final String title;
  final IconData iconData;

  void show(TextStyle style) {
    print('${style.debugLabel.split(' ')[1].toUpperCase()}: $style');
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    // show(textTheme.body2.copyWith(color: Colors.black.withOpacity(0.8)));

    return Row(
      children: <Widget>[
        Icon(iconData, size: 16.0, color: Colors.pink),
        const SizedBox(width: 4.0),
        Expanded(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: textTheme.body1.copyWith(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
