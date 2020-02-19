import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdb_viewer_8/ui/screens/details/movie/widgets/movie_credits_card_base.dart';

class MovieCrewCard extends MovieCreditsCardBase {
  MovieCrewCard(this.crew)
      : super(
            personId: crew.id,
            personName: crew.name,
            personDetails: crew.department,
            profileUrl: crew.getProfileUrl());

  final MovieCrew crew;

  @override
  Widget build(BuildContext context) {
//    print('person: ${crew.id} -  ${crew.name}');
    return super.build(context);
  }
}
