import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Extension on [Color] providing additional color manipulation utilities.
extension ColorExtensions on Color {
  /// Returns a lighter version of this color.
  ///
  /// [amount] The amount to lighten the color by (0-255). Defaults to 10.
  ///
  /// Returns a new [Color] that is lighter than the original.
  Color lighten([int amount = 10]) {
    return Color.fromARGB(
      alpha,
      math.min(255, red + amount),
      math.min(255, green + amount),
      math.min(255, blue + amount),
    );
  }

  /// Returns a darker version of this color.
  ///
  /// [amount] The amount to darken the color by (0-255). Defaults to 10.
  ///
  /// Returns a new [Color] that is darker than the original.
  Color darken([int amount = 10]) {
    return Color.fromARGB(
      alpha,
      math.max(0, red - amount),
      math.max(0, green - amount),
      math.max(0, blue - amount),
    );
  }

  /// Returns the complementary color.
  ///
  /// The complementary color is the color on the opposite side of the color wheel.
  Color get complementary {
    return Color.fromARGB(
      alpha,
      255 - red,
      255 - green,
      255 - blue,
    );
  }

  /// Returns a list of analogous colors.
  ///
  /// Analogous colors are colors that are adjacent to each other on the color wheel.
  ///
  /// [results] The number of analogous colors to generate. Defaults to 6.
  /// [slices] The number of slices to divide the color wheel into. Defaults to 30.
  ///
  /// Returns a [List<Color>] of analogous colors.
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
  ///
  /// [leadingHashSign] Whether to include a leading '#' in the output. Defaults to true.
  ///
  /// Returns a [String] representation of the color in hexadecimal format.
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

  /// Creates a color from a hex string.
  ///
  /// [hexString] The hex string to convert to a color.
  ///
  /// Returns a [Color] created from the provided hex string.
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Returns the luminance of the color.
  ///
  /// Luminance is the relative brightness of the color.
  double get luminance => computeLuminance();

  /// Determines if the color is light.
  ///
  /// A color is considered light if its luminance is greater than 0.5.
  bool get isLight => luminance > 0.5;

  /// Determines if the color is dark.
  ///
  /// A color is considered dark if its luminance is less than or equal to 0.5.
  bool get isDark => !isLight;

  /// Returns a color that contrasts well with this color.
  ///
  /// Uses [ThemeData.estimateBrightnessForColor] to determine the appropriate contrast color.
  Color get contrastColor {
    return ThemeData.estimateBrightnessForColor(this) == Brightness.dark
        ? Colors.white
        : Colors.black;
  }

  /// Blends this color with another color.
  ///
  /// [other] The color to blend with.
  /// [amount] The blend factor (0.0 to 1.0). Defaults to 0.5.
  ///
  /// Returns a new [Color] that is a blend of this color and the other color.
  Color blend(Color other, [double amount = 0.5]) {
    return Color.lerp(this, other, amount)!;
  }

  /// Returns the color as an RGBA string.
  ///
  /// Returns a [String] representation of the color in RGBA format.
  String toRGBAString() =>
      'rgba($red, $green, $blue, ${opacity.toStringAsFixed(2)})';

  /// Creates a MaterialColor swatch from this color.
  ///
  /// Returns a [MaterialColor] swatch based on this color.
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
  ///
  /// [amount] The amount to adjust the saturation by (-1.0 to 1.0).
  ///
  /// Returns a new [Color] with adjusted saturation.
  Color adjustSaturation(double amount) {
    final hslColor = HSLColor.fromColor(this);
    return hslColor
        .withSaturation((hslColor.saturation + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Adjusts the color's hue.
  ///
  /// [amount] The amount to adjust the hue by (in degrees).
  ///
  /// Returns a new [Color] with adjusted hue.
  Color adjustHue(double amount) {
    final hslColor = HSLColor.fromColor(this);
    return hslColor.withHue((hslColor.hue + amount) % 360).toColor();
  }

  /// Returns a list of shades of this color.
  ///
  /// [count] The number of shades to generate. Defaults to 10.
  ///
  /// Returns a [List<Color>] of shades from this color to black.
  List<Color> getShades({int count = 10}) {
    return List.generate(count, (index) {
      final factor = index / (count - 1);
      return Color.lerp(this, Colors.black, factor)!;
    });
  }

  /// Returns a list of tints of this color.
  ///
  /// [count] The number of tints to generate. Defaults to 10.
  ///
  /// Returns a [List<Color>] of tints from this color to white.
  List<Color> getTints({int count = 10}) {
    return List.generate(count, (index) {
      final factor = index / (count - 1);
      return Color.lerp(this, Colors.white, factor)!;
    });
  }

  /// Inverts the color.
  ///
  /// Returns a new [Color] that is the inverse of this color.
  Color get inverted => Color.fromARGB(
        alpha,
        255 - red,
        255 - green,
        255 - blue,
      );

  /// Returns the color as a Flutter `LinearGradient`.
  ///
  /// [endColor] The end color of the gradient. Defaults to a lighter version of this color.
  /// [begin] The starting alignment of the gradient. Defaults to [Alignment.centerLeft].
  /// [end] The ending alignment of the gradient. Defaults to [Alignment.centerRight].
  ///
  /// Returns a [LinearGradient] based on this color.
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
  ///
  /// Returns an [HSVColor] representation of this color.
  HSVColor toHSV() => HSVColor.fromColor(this);

  /// Calculates the distance between this color and another color.
  ///
  /// [other] The color to calculate the distance to.
  ///
  /// Returns a [double] representing the Euclidean distance between the colors in RGB space.
  double distanceTo(Color other) {
    final rDiff = red - other.red;
    final gDiff = green - other.green;
    final bDiff = blue - other.blue;
    return math.sqrt(rDiff * rDiff + gDiff * gDiff + bDiff * bDiff);
  }

  /// Interpolates the color to another color by a given progress.
  ///
  /// [end] The target color to interpolate towards.
  /// [progress] The interpolation progress (0.0 to 1.0).
  ///
  /// Returns a new [Color] interpolated between this color and the end color.
  Color interpolateTo(Color end, double progress) {
    return Color.lerp(this, end, progress)!;
  }

  /// Returns a monochromatic palette based on this color.
  ///
  /// [count] The number of colors in the palette. Defaults to 5.
  ///
  /// Returns a [List<Color>] representing a monochromatic palette.
  List<Color> monochromatic({int count = 5}) {
    final hsvColor = toHSV();
    final step = 1.0 / (count - 1);
    return List.generate(count, (index) {
      final value = (hsvColor.value + step * index).clamp(0.0, 1.0);
      return hsvColor.withValue(value).toColor();
    });
  }
}
