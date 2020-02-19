import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

mixin TmdbHelpersMixin {
  IconData getMediaTypeIcon(TmdbMediaType mediaType) {
    switch (mediaType) {
      case TmdbMediaType.movie:
        return Icons.local_movies;
      case TmdbMediaType.tv:
        return Icons.live_tv;
      case TmdbMediaType.person:
        return Icons.person;
      default:
        return Icons.play_arrow;
    }
  }

  String formatDate(DateTime dt) {
    var pattern = DateFormat.yMd().pattern;
    return DateFormat(pattern).format(dt);
  }

  int calculatePersonAge(DateTime birthDate) {
    if (birthDate == null) return null;
    DateTime nowDate = DateTime.now();
    int age = nowDate.year - birthDate.year;
    int nowMonth = nowDate.month;
    int birthMonth = birthDate.month;
    if (birthMonth > nowMonth) {
      age--;
    } else if (nowMonth == birthMonth) {
      int nowDay = nowDate.day;
      int birthDay = birthDate.day;
      if (birthDay > nowDay) {
        age--;
      }
    }
    return age;
  }

  void openUrl(String url) async {
    if (await url_launcher.canLaunch(url)) {
      await url_launcher.launch(url);
    }
  }
}
