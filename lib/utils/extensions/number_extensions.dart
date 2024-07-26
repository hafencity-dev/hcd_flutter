import 'package:intl/intl.dart';
import 'package:decimal/decimal.dart';
import 'dart:math' as math;

/// Extension methods for [num] to provide additional functionality.
extension NumExtensions on num {
  /// Rounds the number to the specified number of decimal [places].
  num roundTo(int places) =>
      (this * math.pow(10, places)).round() / math.pow(10, places);

  /// Ceils the number to the specified number of decimal [places].
  num ceilTo(int places) =>
      (this * math.pow(10, places)).ceil() / math.pow(10, places);

  /// Floors the number to the specified number of decimal [places].
  num floorTo(int places) =>
      (this * math.pow(10, places)).floor() / math.pow(10, places);

  /// Converts the number to a percentage string.
  ///
  /// [decimalPlaces] specifies the number of decimal places to show.
  /// [locale] specifies the locale for formatting.
  String toPercentString({int decimalPlaces = 2, String? locale}) {
    final formatter = NumberFormat.percentPattern(locale)
      ..minimumFractionDigits = decimalPlaces
      ..maximumFractionDigits = decimalPlaces;
    return formatter.format(this / 100);
  }

  /// Converts the number to a currency string.
  ///
  /// [symbol] specifies the currency symbol.
  /// [decimalPlaces] specifies the number of decimal places to show.
  /// [locale] specifies the locale for formatting.
  String toCurrencyString(
          {String? symbol, int? decimalPlaces, String? locale}) =>
      NumberFormat.currency(
        symbol: symbol,
        decimalDigits: decimalPlaces,
        locale: locale,
      ).format(this);

  /// Raises the number to the power of [exponent].
  num pow(num exponent) => math.pow(this, exponent);

  /// Calculates the square root of the number.
  num sqrt() => math.sqrt(this);

  /// Returns the absolute value of the number.
  num abs() => this.abs();

  /// Checks if the number is positive.
  bool isPositive() => this > 0;

  /// Checks if the number is negative.
  bool isNegative() => this < 0;

  /// Checks if the number is zero.
  bool isZero() => this == 0;

  /// Checks if the number is between [lower] and [upper], inclusive.
  bool isBetween(num lower, num upper) => this >= lower && this <= upper;

  /// Clamps the number between [lower] and [upper].
  num clamp(num lower, num upper) => math.max(lower, math.min(upper, this));

  /// Converts the number to a [Duration] in milliseconds.
  Duration toDuration() => Duration(milliseconds: round());

  /// Converts the number to a [DateTime] from milliseconds since epoch.
  DateTime toDateTime() => DateTime.fromMillisecondsSinceEpoch(round());

  /// Checks if the nth bit is set in the integer representation of the number.
  bool isBitSet(int n) => (toInt() & (1 << n)) != 0;

  /// Sets the nth bit in the integer representation of the number.
  int setBit(int n) => toInt() | (1 << n);

  /// Clears the nth bit in the integer representation of the number.
  int clearBit(int n) => toInt() & ~(1 << n);

  /// Toggles the nth bit in the integer representation of the number.
  int toggleBit(int n) => toInt() ^ (1 << n);

  /// Converts the number to Roman numerals.
  ///
  /// Throws an [ArgumentError] if the number is not between 1 and 3999.
  String toRomanNumerals() {
    if (this <= 0 || this > 3999) {
      throw ArgumentError('Number must be between 1 and 3999');
    }
    final List<String> romanSymbols = [
      'M',
      'CM',
      'D',
      'CD',
      'C',
      'XC',
      'L',
      'XL',
      'X',
      'IX',
      'V',
      'IV',
      'I'
    ];
    final List<int> values = [
      1000,
      900,
      500,
      400,
      100,
      90,
      50,
      40,
      10,
      9,
      5,
      4,
      1
    ];
    String result = '';
    int remaining = round();
    for (int i = 0; i < romanSymbols.length; i++) {
      while (remaining >= values[i]) {
        result += romanSymbols[i];
        remaining -= values[i];
      }
    }
    return result;
  }

  /// Converts the number to its ordinal representation.
  ///
  /// [locale] specifies the locale for formatting.
  String toOrdinal({String? locale}) {
    final int n = round();
    if (locale == null || locale.startsWith('en')) {
      if (n % 100 >= 11 && n % 100 <= 13) return '${n}th';
      switch (n % 10) {
        case 1:
          return '${n}st';
        case 2:
          return '${n}nd';
        case 3:
          return '${n}rd';
        default:
          return '${n}th';
      }
    }
    // For non-English locales, use the number formatter
    return NumberFormat.decimalPattern(locale).format(n);
  }

  /// Converts the number to a [Decimal] for precise decimal arithmetic.
  Decimal toDecimal() => Decimal.parse(toString());

  /// Truncates the number to the specified number of decimal [places].
  double truncateToDecimalPlaces(int places) =>
      (this * math.pow(10, places)).truncate() / math.pow(10, places);

  /// Converts radians to degrees.
  double toDegrees() => this * 180 / math.pi;

  /// Converts degrees to radians.
  double toRadians() => this * math.pi / 180;

  /// Calculates the sine of the number (in radians).
  double sin() => math.sin(toDouble());

  /// Calculates the cosine of the number (in radians).
  double cos() => math.cos(toDouble());

  /// Calculates the tangent of the number (in radians).
  double tan() => math.tan(toDouble());

  /// Formats the number in a compact form (e.g., 1.2K, 1.2M).
  ///
  /// [locale] specifies the locale for formatting.
  String toCompactString({String? locale}) =>
      NumberFormat.compact(locale: locale).format(this);
}

/// Extension methods for [Iterable<num>] to provide statistical operations.
extension NumIterableExtensions<T extends num> on Iterable<T> {
  /// Calculates the average of the numbers in the iterable.
  double get average => isEmpty ? 0 : sum / length;

  /// Calculates the sum of the numbers in the iterable.
  T get sum => fold(0 as T, (a, b) => (a + b) as T);

  /// Calculates the product of the numbers in the iterable.
  T get product => fold(1 as T, (a, b) => (a * b) as T);

  /// Finds the minimum value in the iterable.
  T get min => reduce((a, b) => a < b ? a : b);

  /// Finds the maximum value in the iterable.
  T get max => reduce((a, b) => a > b ? a : b);

  /// Calculates the median of the numbers in the iterable.
  double get median {
    final sorted = toList()..sort();
    final middle = length ~/ 2;
    if (length.isOdd) return sorted[middle].toDouble();
    return (sorted[middle - 1] + sorted[middle]) / 2;
  }

  /// Calculates the standard deviation of the numbers in the iterable.
  double get standardDeviation {
    if (length < 2) return 0;
    final avg = average;
    final variance =
        map((x) => math.pow(x.toDouble() - avg, 2)).reduce((a, b) => a + b) /
            (length - 1);
    return math.sqrt(variance);
  }
}
