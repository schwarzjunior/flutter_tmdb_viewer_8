import 'package:flutter_money_formatter/flutter_money_formatter.dart';

abstract class FormatterHelpers {
  String capitalizeFirstLetter(String value) {
    return value is String ? '${value[0].toUpperCase()}${value.substring(1)}' : null;
  }

  String enumValueToString(dynamic value) {
    return value.toString().replaceFirst('${value.runtimeType.toString()}.', '');
  }

  String formatCurrency(num value, [MoneyFormatterLocation location]) {
    final MoneyFormatter mf = MoneyFormatter(
      amount: value.toDouble(),
      settings: MoneyFormatterSettings.fromLocation(location),
    );
    return mf.output.symbolOnLeft;
  }
}
