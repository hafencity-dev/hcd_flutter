import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hcd/utils/extensions/string_extensions.dart';

void main() {
  group('StringExtensions', () {
    test('isNullOrEmpty', () {
      expect(''.isNullOrEmpty, isTrue);
      expect('  '.isNullOrEmpty, isTrue);
      expect('hello'.isNullOrEmpty, isFalse);
    });

    test('isNotNullOrEmpty', () {
      expect(''.isNotNullOrEmpty, isFalse);
      expect('  '.isNotNullOrEmpty, isFalse);
      expect('hello'.isNotNullOrEmpty, isTrue);
    });

    test('capitalize', () {
      expect('hello'.capitalize(), equals('Hello'));
      expect('WORLD'.capitalize(), equals('WORLD'));
      expect(''.capitalize(), equals(''));
    });

    test('capitalizeEachWord', () {
      expect('hello world'.capitalizeEachWord(), equals('Hello World'));
      expect('HELLO WORLD'.capitalizeEachWord(), equals('HELLO WORLD'));
      expect(''.capitalizeEachWord(), equals(''));
    });

    test('truncate', () {
      expect('Hello, World!'.truncate(8), equals('Hello...'));
      expect('Short'.truncate(10), equals('Short'));
    });

    test('isValidEmail', () {
      expect('test@example.com'.isValidEmail, isTrue);
      expect('invalid-email'.isValidEmail, isFalse);
    });

    test('isValidUrl', () {
      expect('https://example.com'.isValidUrl, isTrue);
      expect('not a url'.isValidUrl, isFalse);
    });

    test('isValidPhoneNumber', () {
      expect('+1234567890'.isValidPhoneNumber, isTrue);
      expect('123'.isValidPhoneNumber, isFalse);
    });

    test('toColor', () {
      expect('#FF0000'.toColor(), equals(Color(0xFFFF0000)));
      expect('FF0000'.toColor(), equals(Color(0xFFFF0000)));
    });

    test('toDateTime', () {
      expect('2023-01-01'.toDateTime(), equals(DateTime(2023, 1, 1)));
      expect('invalid-date'.toDateTime(), isNull);
    });

    test('reverse', () {
      expect('hello'.reverse(), equals('olleh'));
      expect(''.reverse(), equals(''));
    });

    test('isNumeric', () {
      expect('123'.isNumeric(), isTrue);
      expect('12.34'.isNumeric(), isTrue);
      expect('abc'.isNumeric(), isFalse);
    });

    test('removeNonNumeric', () {
      expect('a1b2c3'.removeNonNumeric(), equals('123'));
      expect('123'.removeNonNumeric(), equals('123'));
    });

    test('removeWhitespace', () {
      expect('  hello  world  '.removeWhitespace(), equals('helloworld'));
    });

    test('toSnakeCase', () {
      expect('helloWorld'.toSnakeCase(), equals('hello_world'));
    });

    test('toCamelCase', () {
      expect('hello_world'.toCamelCase(), equals('helloWorld'));
    });

    test('toPascalCase', () {
      expect('hello_world'.toPascalCase(), equals('HelloWorld'));
    });

    test('toKebabCase', () {
      expect('helloWorld'.toKebabCase(), equals('hello-world'));
    });

    test('toTitleCase', () {
      expect('hello world'.toTitleCase(), equals('Hello World'));
    });

    test('padCenter', () {
      expect('hello'.padCenter(10), equals('  hello   '));
      expect('hi'.padCenter(5, '-'), equals('-hi--'));
    });

    test('splitByLength', () {
      expect('abcdefgh'.splitByLength(3), equals(['abc', 'def', 'gh']));
    });

    test('ellipsis', () {
      expect('Hello, World!'.ellipsis(8), equals('Hello...'));
      expect('Short'.ellipsis(10), equals('Short'));
    });

    test('containsAny', () {
      expect('hello world'.containsAny(['hello', 'goodbye']), isTrue);
      expect('hello world'.containsAny(['goodbye', 'hi']), isFalse);
    });

    test('replaceMultiple', () {
      expect('hello world'.replaceMultiple({'hello': 'hi', 'world': 'earth'}),
          equals('hi earth'));
    });

    test('toBase64', () {
      expect('Hello, World!'.toBase64(), equals('SGVsbG8sIFdvcmxkIQ=='));
    });

    test('fromBase64', () {
      expect('SGVsbG8sIFdvcmxkIQ=='.fromBase64(), equals('Hello, World!'));
    });

    test('repeat', () {
      expect('abc'.repeat(3), equals('abcabcabc'));
    });

    test('isAlpha', () {
      expect('abc'.isAlpha(), isTrue);
      expect('abc123'.isAlpha(), isFalse);
    });

    test('isAlphanumeric', () {
      expect('abc123'.isAlphanumeric(), isTrue);
      expect('abc 123'.isAlphanumeric(), isFalse);
    });

    test('stripHtmlTags', () {
      expect('<p>Hello</p>'.stripHtmlTags(), equals('Hello'));
    });

    test('maskCharacters', () {
      expect('1234567890'.maskCharacters(4), equals('1234******'));
    });

    test('toSlug', () {
      expect('Hello World!'.toSlug(), equals('hello-world'));
    });

    test('isStrongPassword', () {
      expect('Abcd1234!'.isStrongPassword(), isTrue);
      expect('weakpassword'.isStrongPassword(), isFalse);
    });

    test('formatAsCreditCard', () {
      expect('1234567890123456'.formatAsCreditCard(),
          equals('1234 5678 9012 3456'));
    });

    test('formatAsPhoneNumber', () {
      expect('1234567890'.formatAsPhoneNumber(), equals('(123) 456-7890'));
    });

    test('initials', () {
      expect('John Doe'.initials(), equals('JD'));
      expect('Alice Bob Charlie'.initials(maxInitials: 3), equals('ABC'));
    });
  });
}
