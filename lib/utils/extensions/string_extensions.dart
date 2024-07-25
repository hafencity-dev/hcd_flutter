import 'dart:convert';
import 'dart:ui';

import 'package:hcd/utils/utils.dart';

extension StringExtensions on String {
  bool get isNullOrEmpty => Utils.isNullOrEmpty(this);
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  String capitalize() {
    if (isNullOrEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String capitalizeEachWord() {
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - 3)}...';
  }

  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

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

  bool get isValidPhoneNumber {
    final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
    return phoneRegex.hasMatch(this);
  }

  Color toColor() {
    final hexColor = replaceAll('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }

  DateTime? toDateTime() {
    return DateTime.tryParse(this);
  }

  String reverse() {
    return String.fromCharCodes(runes.toList().reversed);
  }

  bool isNumeric() {
    return double.tryParse(this) != null;
  }

  String removeNonNumeric() {
    return replaceAll(RegExp(r'[^0-9]'), '');
  }

  String removeWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  String toSnakeCase() {
    return replaceAll(RegExp(r'(?<!^)(?=[A-Z])'), '_').toLowerCase();
  }

  String toCamelCase() {
    return replaceAllMapped(
        RegExp(r'[_\s](\w)'), (match) => match.group(1)!.toUpperCase());
  }

  String toPascalCase() {
    final camelCase = toCamelCase();
    return camelCase[0].toUpperCase() + camelCase.substring(1);
  }

  String toKebabCase() {
    return replaceAll(RegExp(r'(?<!^)(?=[A-Z])'), '-').toLowerCase();
  }

  String toTitleCase() {
    return replaceAllMapped(RegExp(r'\b\w+\b'), (match) {
      final word = match.group(0)!;
      return word.isNotEmpty
          ? word[0].toUpperCase() + word.substring(1).toLowerCase()
          : '';
    });
  }

  String padCenter(int width, [String padding = ' ']) {
    int padLength = width - length;
    if (padLength <= 0) return this;
    int leftPad = padLength ~/ 2;
    int rightPad = padLength - leftPad;
    return '${padding * leftPad}$this${padding * rightPad}';
  }

  List<String> splitByLength(int length) {
    List<String> result = [];
    for (int i = 0; i < this.length; i += length) {
      result.add(
          substring(i, i + length > this.length ? this.length : i + length));
    }
    return result;
  }

  String ellipsis(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - 3)}...';
  }

  bool containsAny(List<String> substrings) {
    return substrings.any((substring) => contains(substring));
  }

  String replaceMultiple(Map<String, String> replacements) {
    String result = this;
    replacements.forEach((key, value) {
      result = result.replaceAll(key, value);
    });
    return result;
  }

  String toBase64() {
    return base64Encode(utf8.encode(this));
  }

  String fromBase64() {
    return utf8.decode(base64Decode(this));
  }

  String repeat(int times) {
    return List.filled(times, this).join();
  }

  bool isAlpha() {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(this);
  }

  bool isAlphanumeric() {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
  }

  String stripHtmlTags() {
    return replaceAll(RegExp(r'<[^>]*>'), '');
  }

  String maskCharacters(int visibleChars, {String mask = '*'}) {
    if (length <= visibleChars) return this;
    return substring(0, visibleChars) + mask.repeat(length - visibleChars);
  }

  String toSlug() {
    return toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-');
  }

  bool isStrongPassword() {
    return RegExp(
            r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$')
        .hasMatch(this);
  }

  String formatAsCreditCard() {
    String cleaned = removeNonNumeric();
    return cleaned.splitByLength(4).join(' ');
  }

  String formatAsPhoneNumber() {
    String cleaned = removeNonNumeric();
    if (cleaned.length == 10) {
      return '(${cleaned.substring(0, 3)}) ${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
    }
    return this;
  }

  String initials({int maxInitials = 2}) {
    List<String> words = trim().split(RegExp(r'\s+'));
    return words.take(maxInitials).map((word) => word[0].toUpperCase()).join();
  }
}
