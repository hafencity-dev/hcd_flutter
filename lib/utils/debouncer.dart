import 'dart:async';

/// A highly configurable Debouncer class for managing debounced operations.
///
/// Features:
/// - Customizable debounce duration.
/// - Option to execute on the leading and/or trailing edge.
/// - Ability to cancel or flush pending actions.
/// - Supports both synchronous and asynchronous actions.
class Debouncer {
  final Duration delay;
  final bool leading;
  final bool trailing;
  Timer? _timer;
  bool _hasPendingAction = false;

  /// Creates a new Debouncer with the specified [delay].
  ///
  /// - [leading]: If true, the action is executed immediately on the first call.
  /// - [trailing]: If true, the action is executed after the debounce period.
  Debouncer({
    required this.delay,
    this.leading = false,
    this.trailing = true,
  });

  /// Runs the provided synchronous [action] using the debouncer's configuration.
  ///
  /// Depending on [leading] and [trailing] flags, the [action] may be executed
  /// immediately and/or after the delay.
  void run(void Function() action) {
    _handleAction(() async {
      action();
    });
  }

  /// Runs the provided asynchronous [action] using the debouncer's configuration.
  ///
  /// Depending on [leading] and [trailing] flags, the [action] may be executed
  /// immediately and/or after the delay.
  Future<void> runAsync(Future<void> Function() action) async {
    await _handleAction(action);
  }

  Future<void> _handleAction(Future<void> Function() action) async {
    if (leading && !_hasPendingAction) {
      _hasPendingAction = true;
      await action();
    }

    _timer?.cancel();
    _timer = Timer(delay, () async {
      if (trailing && _hasPendingAction) {
        await action();
      }
      _hasPendingAction = false;
    });
  }

  /// Cancels any pending actions.
  void cancel() {
    _timer?.cancel();
    _hasPendingAction = false;
  }

  /// Flushes any pending trailing actions immediately.
  ///
  /// If a trailing action is pending, it is executed immediately.
  Future<void> flush(Future<void> Function() action) async {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
      if (trailing && _hasPendingAction) {
        await action();
      }
      _hasPendingAction = false;
    }
  }

  /// Disposes the debouncer by cancelling any pending actions.
  void dispose() {
    cancel();
  }
}
