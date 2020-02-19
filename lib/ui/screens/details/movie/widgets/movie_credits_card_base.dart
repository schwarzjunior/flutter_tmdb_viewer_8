import 'package:flutter/material.dart';
//import 'package:tmdb_viewer_7/screens/details/person/person_details_page.dart';

abstract class MovieCreditsCardBase extends StatelessWidget {
  const MovieCreditsCardBase({
    Key key,
    @required this.personId,
    @required this.personName,
    @required this.personDetails,
    @required this.profileUrl,
  })  : assert(personId != null),
        assert(personName != null),
        super(key: key);

  final int personId;
  final String personName;
  final String personDetails;
  final String profileUrl;

  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /*Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PersonDetailsPage(personId),
        ));*/
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
          borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
          color: Colors.grey[100],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 16.0 / 8.5,
                child: profileUrl != null
                    ? Image.network(profileUrl, fit: BoxFit.cover)
                    : Icon(Icons.person, size: 50, color: Colors.grey[700]),
              ),
              const Divider(color: Colors.black45, height: 1.0, thickness: 2.0),
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  color: Colors.grey[300],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          personName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.body1.copyWith(
                            color: Colors.black,
                            shadows: <Shadow>[
                              const Shadow(
                                offset: const Offset(3, 3),
                                color: Colors.grey,
                                blurRadius: 10.0,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          personDetails,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.body1.copyWith(
                            color: Colors.black54,
                            fontSize: 13.0,
                            fontStyle: FontStyle.italic,
                            shadows: <Shadow>[
                              const Shadow(
                                offset: const Offset(2, 2),
                                color: Colors.grey,
                                blurRadius: 10.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

/*@mustCallSuper
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PersonDetailsPage(personId),
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
          borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
          color: Colors.grey[100],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
          child: Column(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 16.0 / 9.0,
                child: profileUrl != null
                    ? Image.network(profileUrl, fit: BoxFit.cover)
                    : Icon(Icons.person, size: 50, color: Colors.grey[700]),
              ),
              const Divider(color: Colors.black45, height: 1.0, thickness: 2.0),
              Expanded(
                child: Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        personName,
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
              )
            ],
          ),
        ),
      ),
    );
  }*/
}
