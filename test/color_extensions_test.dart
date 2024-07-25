import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hcd/utils/extensions/color_extensions.dart';

void main() {
  group('ColorExtensions', () {
    test('lighten', () {
      final color = Colors.blue;
      final lightened = color.lighten();
      expect(lightened.red, greaterThan(color.red));
      expect(lightened.green, greaterThan(color.green));
      expect(lightened.blue, greaterThan(color.blue));
    });

    test('darken', () {
      final color = Colors.blue;
      final darkened = color.darken();
      expect(darkened.red, lessThan(color.red));
      expect(darkened.green, lessThan(color.green));
      expect(darkened.blue, lessThan(color.blue));
    });

    test('complementary', () {
      final color = Colors.blue;
      final complementary = color.complementary;
      expect(complementary.red, equals(255 - color.red));
      expect(complementary.green, equals(255 - color.green));
      expect(complementary.blue, equals(255 - color.blue));
    });

    test('analogous', () {
      final color = Colors.blue;
      final analogous = color.analogous();
      expect(analogous.length, equals(6));
      expect(analogous.first, isNot(equals(color)));
    });

    test('toHex', () {
      final color = Colors.blue;
      expect(color.toHex(), equals('#ff2196f3'));
      expect(color.toHex(leadingHashSign: false), equals('ff2196f3'));
    });

    test('fromHex', () {
      final hexColor = '#2196f3';
      final color = ColorExtensions.fromHex(hexColor);
      expect(color, equals(Colors.blue[500]));
    });

    test('luminance', () {
      final color = Colors.blue;
      expect(color.luminance, closeTo(0.2, 0.1));
    });

    test('isLight and isDark', () {
      expect(Colors.white.isLight, isTrue);
      expect(Colors.white.isDark, isFalse);
      expect(Colors.black.isLight, isFalse);
      expect(Colors.black.isDark, isTrue);
    });

    test('contrastColor', () {
      expect(Colors.white.contrastColor, equals(Colors.black));
      expect(Colors.black.contrastColor, equals(Colors.white));
    });

    test('blend', () {
      final color1 = Colors.blue;
      final color2 = Colors.red;
      final blended = color1.blend(color2);
      expect(blended.red, greaterThan(color1.red));
      expect(blended.blue, lessThan(color1.blue));
    });

    test('toRGBAString', () {
      final color = Colors.blue;
      expect(color.toRGBAString(), equals('rgba(33, 150, 243, 1.00)'));
    });

    test('toMaterialColor', () {
      final color = Colors.blue;
      final materialColor = color.toMaterialColor();
      expect(materialColor, isA<MaterialColor>());
      expect(materialColor.shade500, equals(color.shade500));
    });

    test('adjustSaturation', () {
      final color = Colors.blue;
      final saturated = color.adjustSaturation(0.2);
      expect(
          saturated.computeLuminance(), closeTo(color.computeLuminance(), 0.1));
    });

    test('adjustHue', () {
      final color = Colors.blue;
      final hueAdjusted = color.adjustHue(60);
      expect(hueAdjusted, isNot(equals(color)));
    });

    test('getShades', () {
      final color = Colors.blue;
      final shades = color.getShades();
      expect(shades.length, equals(10));
      expect(shades.first, equals(color[500]));
      expect(shades.last, equals(Colors.black));
    });

    test('getTints', () {
      final color = Colors.blue;
      final tints = color.getTints();
      expect(tints.length, equals(10));
      expect(tints.first, equals(color[500]));
      expect(tints.last, equals(Colors.white));
    });

    test('inverted', () {
      final color = Colors.blue;
      final inverted = color.inverted;
      expect(inverted.red, equals(255 - color.red));
      expect(inverted.green, equals(255 - color.green));
      expect(inverted.blue, equals(255 - color.blue));
    });

    test('toGradient', () {
      final color = Colors.blue;
      final gradient = color.toGradient();
      expect(gradient, isA<LinearGradient>());
      expect(gradient.colors.first, equals(color));
    });

    test('toHSV', () {
      final color = Colors.blue;
      final hsv = color.toHSV();
      expect(hsv, isA<HSVColor>());
      expect(hsv.toColor(), equals(color[500]));
    });

    test('distanceTo', () {
      final color1 = Colors.blue;
      final color2 = Colors.red;
      final distance = color1.distanceTo(color2);
      expect(distance, greaterThan(0));
    });

    test('interpolateTo', () {
      final color1 = Colors.blue;
      final color2 = Colors.red;
      final interpolated = color1.interpolateTo(color2, 0.5);
      expect(interpolated.red, greaterThan(color1.red));
      expect(interpolated.blue, lessThan(color1.blue));
    });

    test('monochromatic', () {
      final color = Colors.blue[500]!;
      final monochromatic = color.monochromatic();
      expect(monochromatic.length, equals(5));
      expect(monochromatic.contains(color), isTrue);
    });
  });
}
