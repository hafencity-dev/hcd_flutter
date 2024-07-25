import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hcd/utils/extensions/date_time_extensions.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() {
    initializeDateFormatting();
  });

  group('DateTimeExtensions', () {
    test('format', () {
      final date = DateTime(2023, 4, 1);
      expect(date.format(), equals('2023-04-01'));
      expect(date.format(format: 'dd/MM/yyyy'), equals('01/04/2023'));
      expect(date.format(locale: const Locale('es')), equals('2023-04-01'));
    });

    test('isSameDay', () {
      final date1 = DateTime(2023, 4, 1, 10, 30);
      final date2 = DateTime(2023, 4, 1, 15, 45);
      final date3 = DateTime(2023, 4, 2);
      expect(date1.isSameDay(date2), isTrue);
      expect(date1.isSameDay(date3), isFalse);
    });

    test('startOfDay', () {
      final date = DateTime(2023, 4, 1, 10, 30, 45);
      expect(date.startOfDay, equals(DateTime(2023, 4, 1)));
    });

    test('endOfDay', () {
      final date = DateTime(2023, 4, 1, 10, 30, 45);
      expect(date.endOfDay, equals(DateTime(2023, 4, 1, 23, 59, 59, 999)));
    });

    test('isBetween', () {
      final start = DateTime(2023, 4, 1);
      final end = DateTime(2023, 4, 30);
      final date1 = DateTime(2023, 4, 15);
      final date2 = DateTime(2023, 5, 1);
      expect(date1.isBetween(start, end), isTrue);
      expect(date2.isBetween(start, end), isFalse);
    });

    test('differenceInDays', () {
      final date1 = DateTime(2023, 4, 1);
      final date2 = DateTime(2023, 4, 10);
      expect(date1.differenceInDays(date2), equals(9));
      expect(date2.differenceInDays(date1), equals(9));
    });

    test('isToday', () {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));
      expect(today.isToday, isTrue);
      expect(yesterday.isToday, isFalse);
    });

    test('isYesterday', () {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));
      expect(yesterday.isYesterday, isTrue);
      expect(today.isYesterday, isFalse);
    });

    test('isTomorrow', () {
      final today = DateTime.now();
      final tomorrow = today.add(const Duration(days: 1));
      expect(tomorrow.isTomorrow, isTrue);
      expect(today.isTomorrow, isFalse);
    });

    test('startOfWeek', () {
      final date = DateTime(2023, 4, 5); // Wednesday
      expect(date.startOfWeek, equals(DateTime(2023, 4, 3))); // Monday
    });

    test('endOfWeek', () {
      final date = DateTime(2023, 4, 5); // Wednesday
      expect(date.endOfWeek,
          equals(DateTime(2023, 4, 9, 23, 59, 59, 999))); // Sunday
    });

    test('startOfMonth', () {
      final date = DateTime(2023, 4, 15);
      expect(date.startOfMonth, equals(DateTime(2023, 4, 1)));
    });

    test('endOfMonth', () {
      final date = DateTime(2023, 4, 15);
      expect(date.endOfMonth, equals(DateTime(2023, 4, 30, 23, 59, 59, 999)));
    });

    test('timeAgo', () {
      final now = DateTime.now();
      expect(now.timeAgo(), equals('just now'));
      expect(now.subtract(const Duration(minutes: 5)).timeAgo(),
          equals('5 minutes'));
      expect(
          now.subtract(const Duration(hours: 2)).timeAgo(), equals('2 hours'));
      expect(now.subtract(const Duration(days: 3)).timeAgo(), equals('3 days'));
      expect(
          now.subtract(const Duration(days: 60)).timeAgo(), equals('2 months'));
      expect(now.subtract(const Duration(days: 366)).timeAgo(),
          matches(RegExp(r'\d{4}-\d{2}-\d{2}')));
    });

    test('toLocalizedString', () {
      final date = DateTime(2023, 4, 1, 14, 30);
      expect(
          date.toLocalizedString(), matches(RegExp(r'Apr \d+, 2023 2:30 PM')));
      expect(date.toLocalizedString(locale: const Locale('es')),
          matches(RegExp(r'\d+ abr 2023 14:30')));
    });

    test('isWeekend', () {
      expect(DateTime(2023, 4, 1).isWeekend(), isTrue); // Saturday
      expect(DateTime(2023, 4, 2).isWeekend(), isTrue); // Sunday
      expect(DateTime(2023, 4, 3).isWeekend(), isFalse); // Monday
    });

    test('quarter', () {
      expect(DateTime(2023, 1, 1).quarter, equals(1));
      expect(DateTime(2023, 4, 1).quarter, equals(2));
      expect(DateTime(2023, 7, 1).quarter, equals(3));
      expect(DateTime(2023, 10, 1).quarter, equals(4));
    });

    test('addWorkdays', () {
      final date = DateTime(2023, 4, 3); // Monday
      expect(date.addWorkdays(3), equals(DateTime(2023, 4, 6))); // Thursday
      expect(date.addWorkdays(5), equals(DateTime(2023, 4, 10))); // Next Monday
    });
  });

  group('timeAgo localization', () {
    test('returns correct messages for supported languages', () {
      final supportedLanguages = ['es', 'fr', 'de', 'zh', 'en'];
      final now = DateTime.now();
      final oneMinuteAgo = now.subtract(const Duration(minutes: 1));

      for (final lang in supportedLanguages) {
        final justNowMessage = now.timeAgo(locale: Locale(lang));
        expect(justNowMessage, isNotEmpty);

        final oneMinuteMessage = oneMinuteAgo.timeAgo(locale: Locale(lang));
        expect(oneMinuteMessage, isNotEmpty);
        expect(oneMinuteMessage, isNot(equals(justNowMessage)));

        if (lang == 'en') {
          expect(justNowMessage, equals('just now'));
          expect(oneMinuteMessage, equals('1 minute'));
        } else if (lang == 'de') {
          expect(justNowMessage, equals('gerade eben'));
          expect(oneMinuteMessage, equals('1 Minute'));
        }
      }
    });

    test('returns English messages for unsupported language', () {
      final now = DateTime.now();
      final timeAgo = now.timeAgo(locale: Locale('unsupported'));
      expect(timeAgo, equals('just now'));
    });

    test('returns correct localized messages', () {
      final now = DateTime.now();
      final oneMonthAgo = now.subtract(Duration(days: 31));
      final oneDayAgo = now.subtract(Duration(days: 1));
      final oneHourAgo = now.subtract(Duration(hours: 1));
      final oneMinuteAgo = now.subtract(Duration(minutes: 1));

      expect(oneMonthAgo.timeAgo(locale: Locale('en')), equals('1 month'));
      expect(oneDayAgo.timeAgo(locale: Locale('en')), equals('1 day'));
      expect(oneHourAgo.timeAgo(locale: Locale('en')), equals('1 hour'));
      expect(oneMinuteAgo.timeAgo(locale: Locale('en')), equals('1 minute'));
    });
  });
}
