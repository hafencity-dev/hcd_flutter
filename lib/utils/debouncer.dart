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
  bool _isWaiting = false;
  bool _shouldCallAgain = false;
  Function? _pendingAction;
  Completer<void>? _completer;

  /// Creates a new Debouncer with the specified [delay].
  ///
  /// - [leading]: If true, the action is executed immediately on the first call.
  /// - [trailing]: If true, the action is executed after the debounce period.
  Debouncer({
    required this.delay,
    this.leading = false,
    this.trailing = true,
  }) : assert(leading || trailing,
            'At least one of leading or trailing must be true');

  /// Runs the provided synchronous [action] using the debouncer's configuration.
  void run(void Function() action) {
    _execute(() async {
      action();
    });
  }

  /// Runs the provided asynchronous [action] using the debouncer's configuration.
  Future<void> runAsync(Future<void> Function() action) async {
    await _execute(action);
  }

  Future<void> _execute(Function action) async {
    if (leading && !_isWaiting) {
      _isWaiting = true;
      await _invokeAction(action);
    } else {
      _shouldCallAgain = true;
    }

    _pendingAction = action;
    _timer?.cancel();
    _timer = Timer(delay, () async {
      if (trailing && (_shouldCallAgain || !leading)) {
        await _invokeAction(_pendingAction!);
      }
      _reset();
    });
  }

  Future<void> _invokeAction(Function action) async {
    _completer = Completer<void>();
    try {
      var result = action();
      if (result is Future<void>) {
        await result;
      }
      _completer?.complete();
    } catch (e, stack) {
      _completer?.completeError(e, stack);
    }
    await _completer?.future;
  }

  void _reset() {
    _isWaiting = false;
    _shouldCallAgain = false;
    _pendingAction = null;
    _completer = null;
  }

  /// Cancels any pending actions.
  void cancel() {
    _timer?.cancel();
    _reset();
  }

  /// Flushes any pending trailing actions immediately.
  Future<void> flush() async {
    _timer?.cancel();
    if (trailing && _pendingAction != null) {
      await _invokeAction(_pendingAction!);
    }
    _reset();
  }

  /// Disposes the debouncer by cancelling any pending actions.
  void dispose() {
    cancel();
  }
}
