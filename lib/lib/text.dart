import 'package:intl/intl.dart';

final _integerFormatGrouped = NumberFormat();

final _twoDecimalsFormatNotGrouped = NumberFormat()
  ..turnOffGrouping()
  ..minimumFractionDigits = 0
  ..maximumFractionDigits = 2;

final _twoDecimalsFormatGrouped = NumberFormat()
  ..minimumFractionDigits = 0
  ..maximumFractionDigits = 2;

String formatGrouped(int number) {
  return _integerFormatGrouped.format(number);
}

String formatToTwoDecimal(double number, {bool alwaysShowSign = false, bool grouping = false}) {
  final formatter = grouping ? _twoDecimalsFormatGrouped : _twoDecimalsFormatNotGrouped;
  if (number >= 0 && alwaysShowSign) {
    return '+${formatter.format(number)}';
  } else {
    return formatter.format(number);
  }
}

String formatCurrency(double price, String currencyCode, {String? symbol}) {
  final formatter = NumberFormat.currency(name: currencyCode, symbol: symbol)..minimumFractionDigits = 0;
  return formatter.format(price);
}

String formatUSD(double price) {
  return formatCurrency(price, 'USD', symbol: '\$');
}