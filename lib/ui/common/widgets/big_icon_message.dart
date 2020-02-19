import 'package:flutter/material.dart';

class BigIconMessage extends StatelessWidget {
  const BigIconMessage({Key key, this.iconData, this.message}) : super(key: key);

  final IconData iconData;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            iconData,
            size: 120.0,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 15.0),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline,
          ),
          const SizedBox(height: 80.0),
        ],
      ),
    );
  }
}
