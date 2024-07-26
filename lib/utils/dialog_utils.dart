import 'package:flutter/material.dart';

/// A utility class that provides various dialog and notification methods for Flutter applications.
class DialogUtils {
  /// Shows a custom dialog with fade and scale animations.
  ///
  /// [context] The build context.
  /// [child] The widget to be displayed in the dialog.
  /// [barrierDismissible] Whether the dialog can be dismissed by tapping outside.
  /// [barrierColor] The color of the barrier behind the dialog.
  ///
  /// Returns a Future that completes with the dialog's result.
  static Future<T?> showCustomDialog<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
    Color barrierColor = Colors.black54,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      pageBuilder: (_, __, ___) => child,
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: anim,
            child: child,
          ),
        );
      },
    );
  }

  /// Shows a confirmation dialog with customizable text and styles.
  ///
  /// [context] The build context.
  /// [title] The title of the dialog.
  /// [message] The message to be displayed in the dialog.
  /// [confirmText] The text for the confirm button.
  /// [cancelText] The text for the cancel button.
  /// [titleTextStyle] The text style for the title.
  /// [messageTextStyle] The text style for the message.
  /// [confirmTextStyle] The text style for the confirm button.
  /// [cancelTextStyle] The text style for the cancel button.
  ///
  /// Returns a Future<bool?> that completes with true if confirmed, false if cancelled.
  static Future<bool?> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    TextStyle? titleTextStyle,
    TextStyle? messageTextStyle,
    TextStyle? confirmTextStyle,
    TextStyle? cancelTextStyle,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: titleTextStyle),
        content: Text(message, style: messageTextStyle),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText, style: cancelTextStyle),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText, style: confirmTextStyle),
          ),
        ],
      ),
    );
  }

  /// Shows a snackbar with customizable properties.
  ///
  /// [context] The build context.
  /// [message] The message to be displayed in the snackbar.
  /// [duration] The duration for which the snackbar is visible.
  /// [action] An optional action for the snackbar.
  /// [textStyle] The text style for the message.
  /// [backgroundColor] The background color of the snackbar.
  static void showSnackBar({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    TextStyle? textStyle,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: textStyle),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Shows a loading dialog with a circular progress indicator.
  ///
  /// [context] The build context.
  /// [message] The message to be displayed below the progress indicator.
  /// [messageTextStyle] The text style for the message.
  /// [progressIndicatorColor] The color of the progress indicator.
  static Future<void> showLoadingDialog({
    required BuildContext context,
    String message = 'Loading...',
    TextStyle? messageTextStyle,
    Color? progressIndicatorColor,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color?>(
                      progressIndicatorColor ?? Theme.of(context).primaryColor),
                ),
                const SizedBox(height: 16),
                Text(message, style: messageTextStyle),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Shows a toast message overlay.
  ///
  /// [context] The build context.
  /// [message] The message to be displayed in the toast.
  /// [duration] The duration for which the toast is visible.
  /// [textStyle] The text style for the message.
  /// [backgroundColor] The background color of the toast.
  static void showToast({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 2),
    TextStyle? textStyle,
    Color backgroundColor = Colors.black87,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).viewInsets.top + 50,
        left: 24,
        right: 24,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              message,
              style: textStyle ??
                  const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(duration, () => overlayEntry.remove());
  }

  /// Shows a success dialog with a checkmark icon.
  ///
  /// [context] The build context.
  /// [title] The title of the dialog.
  /// [message] The message to be displayed in the dialog.
  /// [buttonText] The text for the dismiss button.
  /// [titleTextStyle] The text style for the title.
  /// [messageTextStyle] The text style for the message.
  /// [buttonTextStyle] The text style for the button.
  /// [iconColor] The color of the checkmark icon.
  /// [iconSize] The size of the checkmark icon.
  static Future<void> showSuccessDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    TextStyle? titleTextStyle,
    TextStyle? messageTextStyle,
    TextStyle? buttonTextStyle,
    Color iconColor = Colors.green,
    double iconSize = 64.0,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: titleTextStyle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: iconColor, size: iconSize),
              const SizedBox(height: 16),
              Text(message, style: messageTextStyle),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(buttonText, style: buttonTextStyle),
            ),
          ],
        );
      },
    );
  }

  /// Shows a bottom sheet with customizable properties.
  ///
  /// [context] The build context.
  /// [child] The widget to be displayed in the bottom sheet.
  /// [isDismissible] Whether the bottom sheet can be dismissed by tapping outside.
  /// [backgroundColor] The background color of the bottom sheet.
  /// [elevation] The elevation of the bottom sheet.
  /// [shape] The shape of the bottom sheet.
  ///
  /// Returns a Future that completes with the bottom sheet's result.
  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: true,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: child,
      ),
    );
  }

  /// Shows an input dialog with a text field.
  ///
  /// [context] The build context.
  /// [title] The title of the dialog.
  /// [initialValue] The initial value of the text field.
  /// [hintText] The hint text for the text field.
  /// [confirmText] The text for the confirm button.
  /// [cancelText] The text for the cancel button.
  /// [keyboardType] The keyboard type for the text field.
  /// [titleTextStyle] The text style for the title.
  /// [hintTextStyle] The text style for the hint text.
  /// [confirmTextStyle] The text style for the confirm button.
  /// [cancelTextStyle] The text style for the cancel button.
  ///
  /// Returns a Future<String?> that completes with the entered text.
  static Future<String?> showInputDialog({
    required BuildContext context,
    required String title,
    String? initialValue,
    String hintText = '',
    String confirmText = 'OK',
    String cancelText = 'Cancel',
    TextInputType keyboardType = TextInputType.text,
    TextStyle? titleTextStyle,
    TextStyle? hintTextStyle,
    TextStyle? confirmTextStyle,
    TextStyle? cancelTextStyle,
  }) async {
    final TextEditingController controller =
        TextEditingController(text: initialValue);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: titleTextStyle),
        content: TextField(
          controller: controller,
          decoration:
              InputDecoration(hintText: hintText, hintStyle: hintTextStyle),
          keyboardType: keyboardType,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(cancelText, style: cancelTextStyle),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text(confirmText, style: confirmTextStyle),
          ),
        ],
      ),
    );
  }

  /// Shows a full-screen dialog.
  ///
  /// [context] The build context.
  /// [child] The widget to be displayed in the full-screen dialog.
  static Future<void> showFullScreenDialog({
    required BuildContext context,
    required Widget child,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) => child,
      ),
    );
  }

  /// Shows an animated dialog with customizable transition.
  ///
  /// [context] The build context.
  /// [builder] The builder function for the dialog content.
  /// [barrierDismissible] Whether the dialog can be dismissed by tapping outside.
  /// [transitionDuration] The duration of the transition animation.
  /// [curve] The curve of the transition animation.
  ///
  /// Returns a Future that completes with the dialog's result.
  static Future<T?> showAnimatedDialog<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Duration transitionDuration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (context, animation1, animation2) => builder(context),
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: transitionDuration,
      transitionBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
            CurvedAnimation(parent: animation1, curve: curve),
          ),
          child: child,
        );
      },
    );
  }

  /// Shows an exit confirmation dialog.
  ///
  /// [context] The build context.
  /// [title] The title of the dialog.
  /// [message] The message to be displayed in the dialog.
  /// [confirmText] The text for the confirm button.
  /// [cancelText] The text for the cancel button.
  /// [titleTextStyle] The text style for the title.
  /// [messageTextStyle] The text style for the message.
  /// [confirmTextStyle] The text style for the confirm button.
  /// [cancelTextStyle] The text style for the cancel button.
  ///
  /// Returns a Future<bool> that completes with true if confirmed, false otherwise.
  static Future<bool> showExitConfirmationDialog(
    BuildContext context, {
    String title = 'Exit App',
    String message = 'Are you sure you want to exit the app?',
    String confirmText = 'Exit',
    String cancelText = 'Cancel',
    TextStyle? titleTextStyle,
    TextStyle? messageTextStyle,
    TextStyle? confirmTextStyle,
    TextStyle? cancelTextStyle,
  }) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title, style: titleTextStyle),
            content: Text(message, style: messageTextStyle),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(cancelText, style: cancelTextStyle),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(confirmText, style: confirmTextStyle),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// Shows a progress dialog with a linear progress indicator.
  ///
  /// [context] The build context.
  /// [progressStream] A stream of double values representing the progress (0.0 to 1.0).
  /// [title] The title of the dialog.
  /// [titleTextStyle] The text style for the title.
  /// [progressTextStyle] The text style for the progress percentage text.
  static Future<void> showProgressDialog({
    required BuildContext context,
    required Stream<double> progressStream,
    String title = 'Loading...',
    TextStyle? titleTextStyle,
    TextStyle? progressTextStyle,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: titleTextStyle),
          content: StreamBuilder<double>(
            stream: progressStream,
            builder: (context, snapshot) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LinearProgressIndicator(
                    value: snapshot.data,
                  ),
                  const SizedBox(height: 16),
                  Text('${((snapshot.data ?? 0) * 100).toStringAsFixed(0)}%',
                      style: progressTextStyle),
                ],
              );
            },
          ),
        );
      },
    );
  }

  /// Shows a date picker dialog.
  ///
  /// [context] The build context.
  ///
  /// Returns a Future<DateTime?> that completes with the selected date.
  static Future<DateTime?> showDatePickerDialog(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    return picked;
  }

  /// Shows a time picker dialog.
  ///
  /// [context] The build context.
  ///
  /// Returns a Future<TimeOfDay?> that completes with the selected time.
  static Future<TimeOfDay?> showTimePickerDialog(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    return picked;
  }

  /// Shows a banner message at the top of the screen.
  ///
  /// [context] The build context.
  /// [message] The message to be displayed in the banner.
  /// [backgroundColor] The background color of the banner.
  /// [textColor] The color of the text in the banner.
  /// [duration] The duration for which the banner is visible.
  /// [textStyle] The text style for the message.
  static void showBanner({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 4),
    TextStyle? textStyle,
  }) {
    ScaffoldMessenger.of(context)
      ..removeCurrentMaterialBanner()
      ..showMaterialBanner(
        MaterialBanner(
          content:
              Text(message, style: textStyle ?? TextStyle(color: textColor)),
          backgroundColor: backgroundColor,
          actions: [
            TextButton(
              child: Text('Dismiss', style: TextStyle(color: textColor)),
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
            ),
          ],
        ),
      );

    Future.delayed(duration, () {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      }
    });
  }
}
