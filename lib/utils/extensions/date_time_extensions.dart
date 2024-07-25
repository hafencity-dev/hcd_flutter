import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

extension DateTimeExtensions on DateTime {
  String format({String? format, Locale? locale}) {
    final formatter = DateFormat(format ?? 'yyyy-MM-dd', locale?.languageCode);
    return formatter.format(this);
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  DateTime get startOfDay => DateTime(year, month, day);

  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  bool isBetween(DateTime start, DateTime end) {
    return isAfter(start) && isBefore(end);
  }

  int differenceInDays(DateTime other) {
    return difference(other).inDays.abs();
  }

  // New methods
  bool get isToday => isSameDay(DateTime.now());

  bool get isYesterday =>
      isSameDay(DateTime.now().subtract(const Duration(days: 1)));

  bool get isTomorrow => isSameDay(DateTime.now().add(const Duration(days: 1)));

  DateTime get startOfWeek => subtract(Duration(days: weekday - 1)).startOfDay;

  DateTime get endOfWeek =>
      add(Duration(days: DateTime.daysPerWeek - weekday)).endOfDay;

  DateTime get startOfMonth => DateTime(year, month);

  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  String timeAgo({Locale? locale}) {
    final now = DateTime.now();
    final difference = now.difference(this);

    final language = locale?.languageCode ?? 'en';
    final messages = _getTimeAgoMessages(language);

    if (difference.inDays > 365) {
      return format(format: 'yyyy-MM-dd', locale: locale);
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? messages['month'] : messages['months']}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? messages['day'] : messages['days']}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? messages['hour'] : messages['hours']}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? messages['minute'] : messages['minutes']}';
    } else {
      return messages['justNow'] ?? 'just now';
    }
  }

  String toLocalizedString({Locale? locale}) {
    final language = locale?.languageCode ?? 'en';
    final formatter = DateFormat.yMMMd(language).add_jm();
    return formatter.format(this);
  }

  bool isWeekend() {
    return weekday == DateTime.saturday || weekday == DateTime.sunday;
  }

  int get quarter => (month - 1) ~/ 3 + 1;

  DateTime addWorkdays(int days) {
    var date = this;
    while (days > 0) {
      date = date.add(const Duration(days: 1));
      if (!date.isWeekend()) {
        days--;
      }
    }
    return date;
  }
}

Map<String, String> _getTimeAgoMessages(String languageCode) {
  switch (languageCode) {
    case 'es':
      return {
        'month': 'mes',
        'months': 'meses',
        'day': 'día',
        'days': 'días',
        'hour': 'hora',
        'hours': 'horas',
        'minute': 'minuto',
        'minutes': 'minutos',
        'justNow': 'ahora mismo',
      };
    case 'fr':
      return {
        'month': 'mois',
        'months': 'mois',
        'day': 'jour',
        'days': 'jours',
        'hour': 'heure',
        'hours': 'heures',
        'minute': 'minute',
        'minutes': 'minutes',
        'justNow': 'à l\'instant',
      };
    case 'de':
      return {
        'month': 'Monat',
        'months': 'Monate',
        'day': 'Tag',
        'days': 'Tage',
        'hour': 'Stunde',
        'hours': 'Stunden',
        'minute': 'Minute',
        'minutes': 'Minuten',
        'justNow': 'gerade eben',
      };
    case 'zh':
      return {
        'month': '个月',
        'months': '个月',
        'day': '天',
        'days': '天',
        'hour': '小时',
        'hours': '小时',
        'minute': '分钟',
        'minutes': '分钟',
        'justNow': '刚刚',
      };
    case 'ja':
      return {
        'month': 'ヶ月',
        'months': 'ヶ月',
        'day': '日',
        'days': '日',
        'hour': '時間',
        'hours': '時間',
        'minute': '分',
        'minutes': '分',
        'justNow': 'たった今',
      };
    case 'ar':
      return {
        'month': 'شهر',
        'months': 'أشهر',
        'day': 'يوم',
        'days': 'أيام',
        'hour': 'ساعة',
        'hours': 'ساعات',
        'minute': 'دقيقة',
        'minutes': 'دقائق',
        'justNow': 'الآن',
      };
    default:
      return {
        'month': 'month',
        'months': 'months',
        'day': 'day',
        'days': 'days',
        'hour': 'hour',
        'hours': 'hours',
        'minute': 'minute',
        'minutes': 'minutes',
        'justNow': 'just now',
      };
  }
}
