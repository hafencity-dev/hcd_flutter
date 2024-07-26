import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

/// A utility class containing various helper methods.
class Utils {
  /// Checks if a value is null or empty.
  ///
  /// Returns true if the [value] is null, an empty string, an empty iterable, or an empty map.
  /// Returns false otherwise.
  static bool isNullOrEmpty(dynamic value) {
    if (value == null) return true;
    if (value is String) return value.trim().isEmpty;
    if (value is Iterable) return value.isEmpty;
    if (value is Map) return value.isEmpty;
    return false;
  }

  /// Attempts to cast a dynamic value to a specified type.
  ///
  /// Returns the [value] cast to type [T] if successful, null otherwise.
  static T? tryCast<T>(dynamic value) {
    return value is T ? value : null;
  }

  /// Generates a unique UUID v4 string.
  ///
  /// Returns a new UUID v4 as a String.
  static String generateUniqueId() {
    return const Uuid().v4();
  }

  /// Checks if the device has an active internet connection.
  ///
  /// Returns a [Future<bool>] that completes with true if connected, false otherwise.
  static Future<bool> isNetworkAvailable() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Hides the soft keyboard.
  ///
  /// [context] is used to obtain the current focus scope.
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}

/// Extension on [Clipboard] to provide additional functionality.
extension ClipboardExtensions on Clipboard {
  /// Retrieves text data from the clipboard.
  ///
  /// Returns a [Future<String?>] that completes with the clipboard text, or null if empty.
  static Future<String?> getData() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }
}

/// A generic class for handling enum-like structures with reverse mapping.
class EnumValues<T> {
  /// The forward mapping from String to enum value.
  Map<String, T> map;

  /// The reverse mapping from enum value to String.
  Map<T, String>? _reverseMap;

  /// Creates a new [EnumValues] instance with the given [map].
  EnumValues(this.map);

  /// Gets the reverse mapping, creating it if it doesn't exist.
  ///
  /// Returns a [Map<T, String>] representing the reverse mapping.
  Map<T, String> get reverse {
    _reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return _reverseMap!;
  }
}
