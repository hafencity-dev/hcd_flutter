import 'package:flutter_test/flutter_test.dart';
import 'dart:math' as math;

import 'package:hcd/utils/extensions/number_extensions.dart';

void main() {
  group('NumExtensions', () {
    test('roundTo', () {
      expect(3.14159.roundTo(2), 3.14);
      expect(3.14159.roundTo(3), 3.142);
    });

    test('ceilTo', () {
      expect(3.14159.ceilTo(2), 3.15);
      expect(3.14159.ceilTo(3), 3.142);
    });

    test('floorTo', () {
      expect(3.14159.floorTo(2), 3.14);
      expect(3.14159.floorTo(3), 3.141);
    });

    test('toPercentString', () {
      expect(75.5.toPercentString(), '75.50%');
      expect(75.5.toPercentString(decimalPlaces: 1), '75.5%');
      expect(75.5.toPercentString(locale: 'de_DE'), '75,50 %');
      expect(75.5.toPercentString(locale: 'fr_FR'), '75,50 %');
      expect(75.5.toPercentString(locale: 'ja_JP'), '75.50%');
    });

    test('toCurrencyString', () {
      expect(1234.56.toCurrencyString(symbol: '\$'), '\$1,234.56');
      expect(
          1234.56.toCurrencyString(symbol: '€', decimalPlaces: 1), '€1,234.6');
    });

    test('pow', () {
      expect(2.pow(3), 8);
      expect(3.pow(2), 9);
    });

    test('sqrt', () {
      expect(9.sqrt(), 3);
      expect(2.sqrt(), closeTo(1.4142, 0.0001));
    });

    test('abs', () {
      expect((-5).abs(), 5);
      expect(5.abs(), 5);
    });

    test('isPositive', () {
      expect(5.isPositive(), true);
      expect((-5).isPositive(), false);
      expect(0.isPositive(), false);
    });

    test('isNegative', () {
      expect(5.isNegative, false);
      expect((-5).isNegative, true);
      expect(0.isNegative, false);
    });

    test('isZero', () {
      expect(0.isZero(), true);
      expect(5.isZero(), false);
      expect((-5).isZero(), false);
    });

    test('isBetween', () {
      expect(5.isBetween(1, 10), true);
      expect(5.isBetween(6, 10), false);
    });

    test('clamp', () {
      expect(5.clamp(1, 10), 5);
      expect(15.clamp(1, 10), 10);
      expect((-5).clamp(1, 10), 1);
    });

    test('toDuration', () {
      expect(1000.toDuration(), Duration(seconds: 1));
      expect(1500.toDuration(), Duration(milliseconds: 1500));
    });

    test('toDateTime', () {
      final now = DateTime.now().millisecondsSinceEpoch;
      expect(now.toDateTime().millisecondsSinceEpoch, now);
    });

    test('isBitSet', () {
      expect(5.isBitSet(0), true);
      expect(5.isBitSet(1), false);
      expect(5.isBitSet(2), true);
    });

    test('setBit', () {
      expect(5.setBit(1), 7);
      expect(5.setBit(2), 5);
    });

    test('clearBit', () {
      expect(5.clearBit(0), 4);
      expect(5.clearBit(2), 1);
    });

    test('toggleBit', () {
      expect(5.toggleBit(0), 4);
      expect(5.toggleBit(1), 7);
    });

    test('toRomanNumerals', () {
      expect(4.toRomanNumerals(), 'IV');
      expect(9.toRomanNumerals(), 'IX');
      expect(14.toRomanNumerals(), 'XIV');
      expect(1999.toRomanNumerals(), 'MCMXCIX');
      expect(() => 4000.toRomanNumerals(), throwsArgumentError);
    });

    test('toOrdinal', () {
      expect(1.toOrdinal(), '1st');
      expect(2.toOrdinal(), '2nd');
      expect(3.toOrdinal(), '3rd');
      expect(4.toOrdinal(), '4th');
      expect(11.toOrdinal(), '11th');
      expect(21.toOrdinal(), '21st');
    });

    test('toDecimal', () {
      expect(3.14.toDecimal().toString(), '3.14');
      expect((-1.23).toDecimal().toString(), '-1.23');
    });

    test('truncateToDecimalPlaces', () {
      expect(3.14159.truncateToDecimalPlaces(2), 3.14);
      expect(3.14159.truncateToDecimalPlaces(3), 3.141);
    });

    test('toDegrees', () {
      expect(math.pi.toDegrees(), closeTo(180, 0.0001));
      expect((math.pi / 2).toDegrees(), closeTo(90, 0.0001));
    });

    test('toRadians', () {
      expect(180.toRadians(), closeTo(math.pi, 0.0001));
      expect(90.toRadians(), closeTo(math.pi / 2, 0.0001));
    });

    test('sin', () {
      expect(0.toRadians().sin(), closeTo(0, 0.0001));
      expect((math.pi / 2).sin(), closeTo(1, 0.0001));
    });

    test('cos', () {
      expect(0.cos(), closeTo(1, 0.0001));
      expect(math.pi.cos(), closeTo(-1, 0.0001));
    });

    test('tan', () {
      expect(0.tan(), closeTo(0, 0.0001));
      expect((math.pi / 4).tan(), closeTo(1, 0.0001));
    });

    test('toCompactString', () {
      expect(1000.toCompactString(), '1K');
      expect(1500000.toCompactString(), '1.5M');
    });
  });

  group('NumIterableExtensions', () {
    final numbers = [1, 2, 3, 4, 5];

    test('average', () {
      expect(numbers.average, 3);
      expect(<num>[].average, 0);
    });

    test('sum', () {
      expect(numbers.sum, 15);
      expect(<num>[].sum, 0);
    });

    test('product', () {
      expect(numbers.product, 120);
      expect(<num>[].product, 1);
    });

    test('min', () {
      expect(numbers.min, 1);
      expect(() => <num>[].min, throwsStateError);
    });

    test('max', () {
      expect(numbers.max, 5);
      expect(() => <num>[].max, throwsStateError);
    });

    test('median', () {
      expect(numbers.median, 3);
      expect([1, 2, 3, 4].median, 2.5);
      expect(<num>[].median, 0);
    });

    test('standardDeviation', () {
      expect(numbers.standardDeviation, closeTo(1.5811, 0.0001));
      expect(<num>[].standardDeviation, 0);
      expect(<num>[1].standardDeviation, 0);
    });
  });
}
