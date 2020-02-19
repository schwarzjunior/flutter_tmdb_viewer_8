import 'package:flutter/material.dart';

class MediaPoster extends StatelessWidget {
  const MediaPoster({Key key, @required this.imageUrl, this.alternativeIcon}) : super(key: key);

  final String imageUrl;
  final IconData alternativeIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.0,
      child: AspectRatio(
        aspectRatio: 16.0 / 9.0,
        child: Container(
          decoration: BoxDecoration(
            image: imageUrl != null
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(imageUrl),
                  )
                : null,
            borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
          ),
          child: imageUrl == null ? Icon(alternativeIcon, size: 60.0) : Container(),
        ),
      ),
    );
  }
}
