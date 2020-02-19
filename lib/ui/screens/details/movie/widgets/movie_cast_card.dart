import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdb_viewer_8/ui/screens/details/movie/widgets/movie_credits_card_base.dart';

class MovieCastCard extends MovieCreditsCardBase {
  MovieCastCard(this.cast)
      : super(
            personId: cast.id,
            personName: cast.name,
            personDetails: cast.character,
            profileUrl: cast.getProfileUrl());

  final MovieCast cast;
}
