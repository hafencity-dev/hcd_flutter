import 'package:intl/intl.dart';
import 'package:decimal/decimal.dart';
import 'dart:math' as math;

extension NumExtensions on num {
  // Rounding
  num roundTo(int places) =>
      (this * math.pow(10, places)).round() / math.pow(10, places);
  num ceilTo(int places) =>
      (this * math.pow(10, places)).ceil() / math.pow(10, places);
  num floorTo(int places) =>
      (this * math.pow(10, places)).floor() / math.pow(10, places);

  // Conversion
  String toPercentString({int decimalPlaces = 2, String? locale}) {
    final formatter = NumberFormat.percentPattern(locale)
      ..minimumFractionDigits = decimalPlaces
      ..maximumFractionDigits = decimalPlaces;
    return formatter.format(this / 100);
  }

  String toCurrencyString(
          {String? symbol, int? decimalPlaces, String? locale}) =>
      NumberFormat.currency(
        symbol: symbol,
        decimalDigits: decimalPlaces,
        locale: locale,
      ).format(this);

  // Math operations
  num pow(num exponent) => math.pow(this, exponent);
  num sqrt() => math.sqrt(this);
  num abs() => this.abs();

  // Comparison
  bool isPositive() => this > 0;
  bool isNegative() => this < 0;
  bool isZero() => this == 0;

  // Range checks
  bool isBetween(num lower, num upper) => this >= lower && this <= upper;
  num clamp(num lower, num upper) => math.max(lower, math.min(upper, this));

  // Time conversion
  Duration toDuration() => Duration(milliseconds: round());
  DateTime toDateTime() => DateTime.fromMillisecondsSinceEpoch(round());

  // Bit operations (for integers)
  bool isBitSet(int n) => (toInt() & (1 << n)) != 0;
  int setBit(int n) => toInt() | (1 << n);
  int clearBit(int n) => toInt() & ~(1 << n);
  int toggleBit(int n) => toInt() ^ (1 << n);

  // Roman numeral conversion
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

  // Ordinal suffix
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

  // Precision handling
  Decimal toDecimal() => Decimal.parse(toString());
  double truncateToDecimalPlaces(int places) =>
      (this * math.pow(10, places)).truncate() / math.pow(10, places);

  // Angle conversions
  double toDegrees() => this * 180 / math.pi;
  double toRadians() => this * math.pi / 180;

  // Trigonometric functions
  double sin() => math.sin(toDouble());
  double cos() => math.cos(toDouble());
  double tan() => math.tan(toDouble());

  // Formatting
  String toCompactString({String? locale}) =>
      NumberFormat.compact(locale: locale).format(this);
}

extension NumIterableExtensions<T extends num> on Iterable<T> {
  // Statistical operations
  double get average => isEmpty ? 0 : sum / length;
  T get sum => fold(0 as T, (a, b) => (a + b) as T);
  T get product => fold(1 as T, (a, b) => (a * b) as T);
  T get min => reduce((a, b) => a < b ? a : b);
  T get max => reduce((a, b) => a > b ? a : b);
  double get median {
    final sorted = toList()..sort();
    final middle = length ~/ 2;
    if (length.isOdd) return sorted[middle].toDouble();
    return (sorted[middle - 1] + sorted[middle]) / 2;
  }

  // Standard deviation
  double get standardDeviation {
    if (length < 2) return 0;
    final avg = average;
    final variance =
        map((x) => math.pow(x.toDouble() - avg, 2)).reduce((a, b) => a + b) /
            (length - 1);
    return math.sqrt(variance);
  }
}
