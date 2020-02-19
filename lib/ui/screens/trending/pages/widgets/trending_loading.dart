import 'package:flutter/material.dart';

class TrendingLoading extends StatelessWidget {
  const TrendingLoading({Key key, this.title, this.iconData}) : super(key: key);

  final String title;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    const Color loadingColor = const Color(0xffbdbdbd);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Loading',
          style: Theme.of(context).textTheme.headline.copyWith(color: loadingColor),
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(iconData ?? Icons.trending_up, color: loadingColor, size: 100.0),
            const SizedBox(width: 8.0),
            Text(
              title ?? '',
              style: Theme.of(context).textTheme.display1.copyWith(color: loadingColor),
            ),
          ],
        ),
        const SizedBox(height: 50.0),
        const Center(
          child: const CircularProgressIndicator(
            valueColor: const AlwaysStoppedAnimation<Color>(loadingColor),
            strokeWidth: 3.0,
          ),
        ),
        const SizedBox(height: 30.0),
      ],
    );
  }
}
