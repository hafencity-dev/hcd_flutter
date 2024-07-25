import 'dart:math' as math;
import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  /// Returns a lighter version of this color.
  Color lighten([int amount = 10]) {
    return Color.fromARGB(
      alpha,
      math.min(255, red + amount),
      math.min(255, green + amount),
      math.min(255, blue + amount),
    );
  }

  /// Returns a darker version of this color.
  Color darken([int amount = 10]) {
    return Color.fromARGB(
      alpha,
      math.max(0, red - amount),
      math.max(0, green - amount),
      math.max(0, blue - amount),
    );
  }

  /// Returns the complementary color.
  Color get complementary {
    return Color.fromARGB(
      alpha,
      255 - red,
      255 - green,
      255 - blue,
    );
  }

  /// Returns a list of analogous colors.
  List<Color> analogous({int results = 6, int slices = 30}) {
    final hslColor = HSLColor.fromColor(this);
    final hueSlice = 360 / slices;

    return List<Color>.generate(results, (i) {
      final hue = (hslColor.hue + (i * hueSlice)) % 360;
      return HSLColor.fromAHSL(
              alpha / 255, hue, hslColor.saturation, hslColor.lightness)
          .toColor();
    });
  }

  /// Converts the color to a hex string.
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

  /// Creates a color from a hex string.
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Returns the luminance of the color.
  double get luminance => computeLuminance();

  /// Determines if the color is light.
  bool get isLight => luminance > 0.5;

  /// Determines if the color is dark.
  bool get isDark => !isLight;

  /// Returns a color that contrasts well with this color.
  //Color get contrastColor => isLight ? Colors.black : Colors.white;
  Color get contrastColor {
    return ThemeData.estimateBrightnessForColor(this) == Brightness.dark
        ? Colors.white
        : Colors.black;
  }

  /// Blends this color with another color.
  Color blend(Color other, [double amount = 0.5]) {
    return Color.lerp(this, other, amount)!;
  }

  /// Returns the color as an RGBA string.
  String toRGBAString() =>
      'rgba($red, $green, $blue, ${opacity.toStringAsFixed(2)})';

  /// Creates a MaterialColor swatch from this color.
  MaterialColor toMaterialColor() {
    final strengths = <double>[.05, .1, .2, .3, .4, .5, .6, .7, .8, .9];
    final swatch = <int, Color>{};
    for (final strength in strengths) {
      final ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        red + ((ds < 0 ? red : (255 - red)) * ds).round(),
        green + ((ds < 0 ? green : (255 - green)) * ds).round(),
        blue + ((ds < 0 ? blue : (255 - blue)) * ds).round(),
        1,
      );
    }
    return MaterialColor(value, swatch);
  }

  /// Adjusts the color's saturation.
  Color adjustSaturation(double amount) {
    final hslColor = HSLColor.fromColor(this);
    return hslColor
        .withSaturation((hslColor.saturation + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Adjusts the color's hue.
  Color adjustHue(double amount) {
    final hslColor = HSLColor.fromColor(this);
    return hslColor.withHue((hslColor.hue + amount) % 360).toColor();
  }

  /// Returns a list of shades of this color.
  List<Color> getShades({int count = 10}) {
    return List.generate(count, (index) {
      final factor = index / (count - 1);
      return Color.lerp(this, Colors.black, factor)!;
    });
  }

  /// Returns a list of tints of this color.
  List<Color> getTints({int count = 10}) {
    return List.generate(count, (index) {
      final factor = index / (count - 1);
      return Color.lerp(this, Colors.white, factor)!;
    });
  }

  /// Inverts the color.
  Color get inverted => Color.fromARGB(
        alpha,
        255 - red,
        255 - green,
        255 - blue,
      );

  /// Returns the color as a Flutter `LinearGradient`.
  LinearGradient toGradient(
      {Color? endColor,
      AlignmentGeometry begin = Alignment.centerLeft,
      AlignmentGeometry end = Alignment.centerRight}) {
    return LinearGradient(
      colors: [this, endColor ?? lighten(20)],
      begin: begin,
      end: end,
    );
  }

  /// Returns the color as HSV (Hue, Saturation, Value).
  HSVColor toHSV() => HSVColor.fromColor(this);

  /// Calculates the distance between this color and another color.
  double distanceTo(Color other) {
    final rDiff = red - other.red;
    final gDiff = green - other.green;
    final bDiff = blue - other.blue;
    return math.sqrt(rDiff * rDiff + gDiff * gDiff + bDiff * bDiff);
  }

  /// Interpolates the color to another color by a given progress (0.0 to 1.0).
  Color interpolateTo(Color end, double progress) {
    return Color.lerp(this, end, progress)!;
  }

  /// Returns a monochromatic palette based on this color.
  List<Color> monochromatic({int count = 5}) {
    final hsvColor = toHSV();
    final step = 1.0 / (count - 1);
    return List.generate(count, (index) {
      final value = (hsvColor.value + step * index).clamp(0.0, 1.0);
      return hsvColor.withValue(value).toColor();
    });
  }
}
