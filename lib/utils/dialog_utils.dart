import 'package:flutter/material.dart';

class DialogUtils {
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
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color?>(
                      progressIndicatorColor ?? Theme.of(context).primaryColor),
                ),
                SizedBox(height: 16),
                Text(message, style: messageTextStyle),
              ],
            ),
          ),
        );
      },
    );
  }

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
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              message,
              style: textStyle ?? TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(duration, () => overlayEntry.remove());
  }

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
              SizedBox(height: 16),
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
          RoundedRectangleBorder(
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
          position: Tween(begin: Offset(0, 1), end: Offset.zero).animate(
            CurvedAnimation(parent: animation1, curve: curve),
          ),
          child: child,
        );
      },
    );
  }

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
                  SizedBox(height: 16),
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

  static Future<DateTime?> showDatePickerDialog(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    return picked;
  }

  static Future<TimeOfDay?> showTimePickerDialog(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    return picked;
  }

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
