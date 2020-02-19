import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdb_viewer_8/ui/screens/details/movie/movie_details_page.dart';

class CreditCard extends StatelessWidget {
  const CreditCard(this.credit, {Key key}) : super(key: key);

  final PeopleCredit credit;

  @override
  Widget build(BuildContext context) {
    final bool hasImage = (credit.getBackdropUrl() ?? credit.getPosterUrl()) != null;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MovieDetailsPage(credit.id),
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[100],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Column(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 16.0 / 9.0,
                child: hasImage
                    ? Image.network(credit.getBackdropUrl() ?? credit.getPosterUrl(), fit: BoxFit.cover)
                    : Icon(Icons.local_movies, size: 50, color: Colors.grey[700]),
              ),
              const Divider(color: Colors.black45, height: 1.0, thickness: 2.0),
              Expanded(
                child: Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        credit.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.body1.copyWith(
                          color: Colors.black,
                          shadows: <Shadow>[
                            const Shadow(
                              offset: const Offset(2, 2),
                              color: Colors.grey,
                              blurRadius: 10.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
