import 'dart:convert';
import 'dart:ui';

import 'package:hcd/utils/utils.dart';

/// Extension methods for [String] to provide additional functionality.
extension StringExtensions on String {
  /// Checks if the string is null or empty.
  bool get isNullOrEmpty => Utils.isNullOrEmpty(this);

  /// Checks if the string is not null and not empty.
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Capitalizes the first character of the string.
  ///
  /// Returns the original string if it's empty.
  String capitalize() {
    if (isNullOrEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalizes the first character of each word in the string.
  String capitalizeEachWord() {
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Truncates the string to a specified maximum length.
  ///
  /// If the string is longer than [maxLength], it will be truncated and
  /// appended with '...'.
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - 3)}...';
  }

  /// Checks if the string is a valid email address.
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  /// Checks if the string is a valid URL.
  bool get isValidUrl {
    final urlPattern = RegExp(
      r'^(https?:\/\/)?' // protocol (e.g., http:// or https://)
      r'((([a-z\d]([a-z\d-]*[a-z\d])*)\.)+[a-z]{2,}|' // domain name (e.g., www.example.com)
      r'((\d{1,3}\.){3}\d{1,3}))' // OR ip (v4) address (e.g., 192.168.0.1)
      r'(\:\d+)?' // port (e.g., :8080)
      r'(\/[-a-z\d%_.~+]*)*' // path (e.g., /path/to/page)
      r'(\?[;&a-z\d%_.~+=-]*)?' // query string (e.g., ?param1=value1&param2=value2)
      r'(\#[-a-z\d_]*)?$', // fragment locator (e.g., #section1)
      caseSensitive: false,
    );
    return urlPattern.hasMatch(this);
  }

  /// Checks if the string is a valid phone number.
  bool get isValidPhoneNumber {
    final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
    return phoneRegex.hasMatch(this);
  }

  /// Converts the string (assumed to be a hex color) to a [Color] object.
  Color toColor() {
    final hexColor = replaceAll('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }

  /// Attempts to parse the string as a [DateTime] object.
  ///
  /// Returns null if parsing fails.
  DateTime? toDateTime() {
    return DateTime.tryParse(this);
  }

  /// Reverses the characters in the string.
  String reverse() {
    return String.fromCharCodes(runes.toList().reversed);
  }

  /// Checks if the string represents a numeric value.
  bool isNumeric() {
    return double.tryParse(this) != null;
  }

  /// Removes all non-numeric characters from the string.
  String removeNonNumeric() {
    return replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// Removes all whitespace characters from the string.
  String removeWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Converts the string to snake_case.
  String toSnakeCase() {
    return replaceAll(RegExp(r'(?<!^)(?=[A-Z])'), '_').toLowerCase();
  }

  /// Converts the string to camelCase.
  String toCamelCase() {
    return replaceAllMapped(
        RegExp(r'[_\s](\w)'), (match) => match.group(1)!.toUpperCase());
  }

  /// Converts the string to PascalCase.
  String toPascalCase() {
    final camelCase = toCamelCase();
    return camelCase[0].toUpperCase() + camelCase.substring(1);
  }

  /// Converts the string to kebab-case.
  String toKebabCase() {
    return replaceAll(RegExp(r'(?<!^)(?=[A-Z])'), '-').toLowerCase();
  }

  /// Converts the string to Title Case.
  String toTitleCase() {
    return replaceAllMapped(RegExp(r'\b\w+\b'), (match) {
      final word = match.group(0)!;
      return word.isNotEmpty
          ? word[0].toUpperCase() + word.substring(1).toLowerCase()
          : '';
    });
  }

  /// Centers the string within a specified width, padding with a given character.
  ///
  /// If the string is already longer than [width], it will be returned unchanged.
  String padCenter(int width, [String padding = ' ']) {
    int padLength = width - length;
    if (padLength <= 0) return this;
    int leftPad = padLength ~/ 2;
    int rightPad = padLength - leftPad;
    return '${padding * leftPad}$this${padding * rightPad}';
  }

  /// Splits the string into chunks of a specified length.
  List<String> splitByLength(int length) {
    List<String> result = [];
    for (int i = 0; i < this.length; i += length) {
      result.add(
          substring(i, i + length > this.length ? this.length : i + length));
    }
    return result;
  }

  /// Truncates the string to a specified maximum length and adds an ellipsis.
  ///
  /// If the string is longer than [maxLength], it will be truncated and
  /// appended with '...'.
  String ellipsis(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - 3)}...';
  }

  /// Checks if the string contains any of the given substrings.
  bool containsAny(List<String> substrings) {
    return substrings.any((substring) => contains(substring));
  }

  /// Replaces multiple substrings in the string based on a map of replacements.
  String replaceMultiple(Map<String, String> replacements) {
    String result = this;
    replacements.forEach((key, value) {
      result = result.replaceAll(key, value);
    });
    return result;
  }

  /// Encodes the string to Base64.
  String toBase64() {
    return base64Encode(utf8.encode(this));
  }

  /// Decodes the string from Base64.
  String fromBase64() {
    return utf8.decode(base64Decode(this));
  }

  /// Repeats the string a specified number of times.
  String repeat(int times) {
    return List.filled(times, this).join();
  }

  /// Checks if the string contains only alphabetic characters.
  bool isAlpha() {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(this);
  }

  /// Checks if the string contains only alphanumeric characters.
  bool isAlphanumeric() {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
  }

  /// Removes all HTML tags from the string.
  String stripHtmlTags() {
    return replaceAll(RegExp(r'<[^>]*>'), '');
  }

  /// Masks characters in the string, leaving a specified number of characters visible.
  String maskCharacters(int visibleChars, {String mask = '*'}) {
    if (length <= visibleChars) return this;
    return substring(0, visibleChars) + mask.repeat(length - visibleChars);
  }

  /// Converts the string to a URL-friendly slug.
  String toSlug() {
    return toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-');
  }

  /// Checks if the string is a strong password.
  ///
  /// A strong password must contain at least one uppercase letter, one lowercase letter,
  /// one digit, one special character, and be at least 8 characters long.
  bool isStrongPassword() {
    return RegExp(
            r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$')
        .hasMatch(this);
  }

  /// Formats the string as a credit card number with spaces every 4 digits.
  String formatAsCreditCard() {
    String cleaned = removeNonNumeric();
    return cleaned.splitByLength(4).join(' ');
  }

  /// Formats the string as a US phone number (assuming 10 digits).
  String formatAsPhoneNumber() {
    String cleaned = removeNonNumeric();
    if (cleaned.length == 10) {
      return '(${cleaned.substring(0, 3)}) ${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
    }
    return this;
  }

  /// Extracts initials from the string, up to a specified maximum number.
  ///
  /// The string is assumed to contain words separated by spaces.
  String initials({int maxInitials = 2}) {
    List<String> words = trim().split(RegExp(r'\s+'));
    return words.take(maxInitials).map((word) => word[0].toUpperCase()).join();
  }
}
