import 'package:flutter_test/flutter_test.dart';
import 'package:hcd/utils/app_logger.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'dart:io';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {});

  group('AppLogger', () {
    test('logging methods should throw when not initialized', () {
      expect(() => AppLogger.trace('Trace message'), throwsStateError);
      expect(() => AppLogger.debug('Debug message'), throwsStateError);
      expect(() => AppLogger.info('Info message'), throwsStateError);
      expect(() => AppLogger.warning('Warning message'), throwsStateError);
      expect(() => AppLogger.error('Error message'), throwsStateError);
      expect(() => AppLogger.wtf('WTF message'), throwsStateError);
    });

    test('initialize should set up logger correctly', () async {
      await AppLogger.initialize(logToFile: false);
      expect(AppLogger.trace, isA<Function>());
      expect(AppLogger.debug, isA<Function>());
      expect(AppLogger.info, isA<Function>());
      expect(AppLogger.warning, isA<Function>());
      expect(AppLogger.error, isA<Function>());
      expect(AppLogger.wtf, isA<Function>());
    });

    test('logging methods should not throw when initialized', () async {
      await AppLogger.initialize();
      expect(() => AppLogger.trace('Trace message'), returnsNormally);
      expect(() => AppLogger.debug('Debug message'), returnsNormally);
      expect(() => AppLogger.info('Info message'), returnsNormally);
      expect(() => AppLogger.warning('Warning message'), returnsNormally);
      expect(() => AppLogger.error('Error message'), returnsNormally);
      expect(() => AppLogger.wtf('WTF message'), returnsNormally);
    });
  });
}
