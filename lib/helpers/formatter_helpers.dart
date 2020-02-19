abstract class FormatterHelpers {
  String capitalizeFirstLetter(String value) {
    return value is String ? '${value[0].toUpperCase()}${value.substring(1)}' : null;
  }

  String enumValueToString(dynamic value) {
    return value.toString().replaceFirst('${value.runtimeType.toString()}.', '');
  }
}
