import 'package:flutter/material.dart';

class MediaTile extends StatelessWidget {
  const MediaTile({Key key, this.title, this.iconData}) : super(key: key);

  final String title;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(iconData, size: 16.0, color: Colors.pink),
        const SizedBox(width: 4.0),
        Expanded(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.body1.copyWith(
                  color: Colors.grey[600],
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}
