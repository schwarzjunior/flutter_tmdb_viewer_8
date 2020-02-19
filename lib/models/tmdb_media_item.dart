import 'package:tmdb_api/tmdb_api.dart';

class TmdbMediaItem {
  TmdbMediaItem({
    this.id,
    this.name,
    this.description,
    this.dateTime,
    this.imageUrl,
    this.homepage,
    this.mediaType,
  });

  final int id;
  final String name;
  final String description;
  final DateTime dateTime;
  final String imageUrl;
  final String homepage;
  final TmdbMediaType mediaType;

  factory TmdbMediaItem.fromMultiSearch(MultiSearchMediaObject o) {
    if (o is MultiSearchMovie)
      return TmdbMediaItem.fromMovie(o);
    else if (o is MultiSearchTv)
      return TmdbMediaItem.fromTv(o);
    else if (o is MultiSearchPerson)
      return TmdbMediaItem.fromPerson(o);
    else
      return TmdbMediaItem.fromPerson(o);
  }

  factory TmdbMediaItem.fromMovie(MultiSearchMovie o) {
    return TmdbMediaItem(
      id: o.id,
      name: o.title,
      description: o.overview,
      dateTime: o.releaseDate,
      imageUrl: o.getBackdropUrl() ?? o.getPosterUrl(),
      homepage: null,
      mediaType: o.mediaType,
    );
  }

  factory TmdbMediaItem.fromTv(MultiSearchTv o) {
    return TmdbMediaItem(
      id: o.id,
      name: o.name,
      description: o.overview,
      dateTime: o.firstAirDate,
      imageUrl: o.getBackdropUrl() ?? o.getPosterUrl(),
      homepage: null,
      mediaType: o.mediaType,
    );
  }

  factory TmdbMediaItem.fromPerson(MultiSearchPerson o) {
    return TmdbMediaItem(
      id: o.id,
      name: o.name,
      description: o.knownForDepartment,
      dateTime: _dateTimeFromString(''),
      imageUrl: o.getProfileUrl(),
      homepage: null,
      mediaType: o.mediaType,
    );
  }

  factory TmdbMediaItem.fromJson(Map<String, dynamic> json) {
    return TmdbMediaItem(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      dateTime: _dateTimeFromString(json['date_time'] as String),
      imageUrl: json['image_url'] as String,
      homepage: json['homepage'] as String,
      mediaType: _mediaTypeFromString(json['media_type'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'date_time': _dateTimeToString(dateTime),
      'image_url': imageUrl,
      'homepage': homepage,
      'media_type': _mediaTypeToString(mediaType),
    };
  }

  @override
  bool operator ==(o) => o is TmdbMediaItem && o.id == id;

  @override
  int get hashCode => id.hashCode;

  static DateTime _dateTimeFromString(String value) {
    return DateTime.tryParse(value ?? '');
  }

  static String _dateTimeToString(DateTime dt) {
    return dt == null
        ? ''
        : '${_padLeftZeros(dt.year, 4)}'
            '-${_padLeftZeros(dt.month)}'
            '-${_padLeftZeros(dt.day)}';
  }

  static TmdbMediaType _mediaTypeFromString(String value) {
    if (value == 'movie')
      return TmdbMediaType.movie;
    else if (value == 'tv')
      return TmdbMediaType.tv;
    else if (value == 'person')
      return TmdbMediaType.person;
    else
      return TmdbMediaType.other;
  }

  static String _mediaTypeToString(TmdbMediaType mediaType) {
    switch (mediaType) {
      case TmdbMediaType.movie:
        return 'movie';
      case TmdbMediaType.tv:
        return 'tv';
      case TmdbMediaType.person:
        return 'person';
      case TmdbMediaType.other:
      default:
        return '';
    }
  }

  static String _padLeftZeros(num value, [int size = 2]) {
    return value == null ? '' : value.toString().padLeft(size, '0');
  }
}
