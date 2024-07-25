import 'package:hcd/utils/extensions/date_time_extensions.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// A highly customizable and feature-rich logging utility for Flutter applications.
///
/// This class provides a centralized logging mechanism with support for console
/// and file logging, customizable log levels, and various output formats.
class AppLogger {
  static late final Logger _logger;
  static late final String _logFilePath;
  static bool _initialized = false;

  /// Initializes the AppLogger with custom configurations.
  ///
  /// This method must be called before using any logging functions.
  ///
  /// Parameters:
  /// - [filter]: Custom log filter (default: ProductionFilter)
  /// - [printer]: Custom log printer (default: PrettyPrinter with predefined settings)
  /// - [output]: Custom log output
  /// - [level]: Minimum log level (default: Level.debug)
  /// - [synchronous]: Whether to log synchronously
  /// - [includeStackTrace]: Whether to include stack traces in logs
  /// - [logToFile]: Whether to save logs to a file (default: false)
  ///
  /// Throws a [StateError] if called more than once.
  static Future<void> initialize({
    LogFilter? filter,
    LogPrinter? printer,
    LogOutput? output,
    Level? level,
    bool? synchronous,
    bool? includeStackTrace,
    bool logToFile = false,
  }) async {
    if (_initialized) return;

    final logFilter = filter ?? ProductionFilter();
    final logPrinter = printer ??
        PrettyPrinter(
          methodCount: 2,
          errorMethodCount: 8,
          lineLength: 120,
          colors: true,
          printEmojis: true,
          dateTimeFormat: (dateTime) =>
              dateTime.format(format: 'dd/MM/yyyy | HH:mm:ss'),
        );

    LogOutput? logOutput = output;
    if (logToFile) {
      final directory = await getApplicationDocumentsDirectory();
      _logFilePath = '${directory.path}/app_logs.txt';
      logOutput =
          MultiOutput([ConsoleOutput(), FileOutput(file: File(_logFilePath))]);
    }

    _logger = Logger(
      filter: logFilter,
      printer: logPrinter,
      output: logOutput,
      level: level ?? Level.debug,
    );

    _initialized = true;
  }

  /// Checks if the logger has been initialized.
  ///
  /// Throws a [StateError] if the logger hasn't been initialized.
  static void _checkInitialization() {
    if (!_initialized) {
      throw StateError(
          'AppLogger has not been initialized. Call AppLogger.initialize() first.');
    }
  }

  /// Logs a message at the "trace" level.
  ///
  /// Parameters:
  /// - [message]: The message to log
  /// - [error]: An optional error object
  /// - [stackTrace]: An optional stack trace
  static void trace(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _checkInitialization();
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  /// Logs a message at the "debug" level.
  ///
  /// Parameters:
  /// - [message]: The message to log
  /// - [error]: An optional error object
  /// - [stackTrace]: An optional stack trace
  static void debug(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _checkInitialization();
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Logs a message at the "info" level.
  ///
  /// Parameters:
  /// - [message]: The message to log
  /// - [error]: An optional error object
  /// - [stackTrace]: An optional stack trace
  static void info(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _checkInitialization();
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Logs a message at the "warning" level.
  ///
  /// Parameters:
  /// - [message]: The message to log
  /// - [error]: An optional error object
  /// - [stackTrace]: An optional stack trace
  static void warning(dynamic message,
      {dynamic error, StackTrace? stackTrace}) {
    _checkInitialization();
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Logs a message at the "error" level.
  ///
  /// Parameters:
  /// - [message]: The message to log
  /// - [error]: An optional error object
  /// - [stackTrace]: An optional stack trace
  static void error(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _checkInitialization();
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Logs a message at the "wtf" (What a Terrible Failure) level.
  ///
  /// Parameters:
  /// - [message]: The message to log
  /// - [error]: An optional error object
  /// - [stackTrace]: An optional stack trace
  static void wtf(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    _checkInitialization();
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// Retrieves the content of the log file.
  ///
  /// Returns an empty string if file logging is not enabled or the file doesn't exist.
  ///
  /// Returns:
  /// A [Future] that completes with the log content as a [String].
  static Future<String> getLogContent() async {
    _checkInitialization();
    if (_logFilePath.isNotEmpty) {
      final file = File(_logFilePath);
      if (await file.exists()) {
        return await file.readAsString();
      }
    }
    return '';
  }

  /// Clears the contents of the log file.
  ///
  /// This method has no effect if file logging is not enabled.
  static Future<void> clearLogs() async {
    _checkInitialization();
    if (_logFilePath.isNotEmpty) {
      final file = File(_logFilePath);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }
}

/// A custom [LogOutput] implementation that writes log messages to a file.
class FileOutput extends LogOutput {
  final File file;
  final bool overrideExisting;
  IOSink? _sink;

  /// Creates a new [FileOutput] instance.
  ///
  /// Parameters:
  /// - [file]: The [File] object to write logs to
  /// - [overrideExisting]: Whether to override existing log file content (default: false)
  FileOutput({required this.file, this.overrideExisting = false});

  @override
  Future<void> init() async {
    _sink = file.openWrite(
        mode: overrideExisting ? FileMode.writeOnly : FileMode.writeOnlyAppend);
  }

  @override
  void output(OutputEvent event) {
    _sink?.writeAll(event.lines, '\n');
    _sink?.writeln();
  }

  @override
  Future<void> destroy() async {
    await _sink?.flush();
    await _sink?.close();
  }
}
