part of 'app_themes.dart';

final TextStyle _baseTextStyle = TextStyle(
  inherit: true,
  fontFamily: 'Roboto',
  textBaseline: TextBaseline.alphabetic,
  decoration: TextDecoration.none,
);

final TextStyle _body1 = _baseTextStyle.merge(TextStyle(
  inherit: true,
  color: const Color(0xcc000000), // opacity: 0.8
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
));

final TextStyle _body2 = _baseTextStyle.merge(TextStyle(
  inherit: true,
  color: const Color(0x99000000), // opacity: 0.6
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
));
