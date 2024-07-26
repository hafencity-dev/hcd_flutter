import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:hcd/utils/utils.dart';

/// Extension on [BuildContext] to provide convenient access to various Flutter APIs and utilities.
extension BuildContextExtensions on BuildContext {
  /// Theme related getters

  /// Returns the current [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// Returns the current [TextTheme].
  TextTheme get textTheme => theme.textTheme;

  /// Returns the current [ColorScheme].
  ColorScheme get colorScheme => theme.colorScheme;

  /// Media query related getters

  /// Returns the current [MediaQueryData].
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Returns the current screen width.
  double get screenWidth => mediaQuery.size.width;

  /// Returns the current screen height.
  double get screenHeight => mediaQuery.size.height;

  /// Returns the current screen padding.
  EdgeInsets get padding => mediaQuery.padding;

  /// Returns the current view insets.
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// Returns true if the keyboard is currently visible.
  bool get isKeyboardVisible => mediaQuery.viewInsets.bottom > 0;

  /// Returns the current screen orientation.
  Orientation get orientation => mediaQuery.orientation;

  /// Returns true if the device is in landscape orientation.
  bool get isLandscape => orientation == Orientation.landscape;

  /// Returns true if the device is in portrait orientation.
  bool get isPortrait => orientation == Orientation.portrait;

  /// Device related getters

  /// Returns true if the device is a tablet (screen width > 600).
  bool get isTablet => screenWidth > 600;

  /// Returns true if the device is a phone (screen width <= 600).
  bool get isPhone => screenWidth <= 600;

  /// Navigation related getters

  /// Returns the current [NavigatorState].
  NavigatorState get navigator => Navigator.of(this);

  /// Returns the current [GoRouter] instance.
  GoRouter get goRouter => GoRouter.of(this);

  /// Other common widget getters

  /// Returns the current [FocusScopeNode].
  FocusScopeNode get focusScope => FocusScope.of(this);

  /// Returns the current [ScaffoldState].
  ScaffoldState get scaffold => Scaffold.of(this);

  /// Returns the current [ScaffoldMessengerState].
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  /// Snackbar and dialog helpers

  /// Shows a snackbar with the given [message] and optional parameters.
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
    Color? backgroundColor,
    Color? textColor,
    double? elevation,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    ShapeBorder? shape,
    SnackBarBehavior? behavior,
    AnimationController? animation,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
        elevation: elevation,
        margin: margin,
        padding: padding,
        shape: shape,
        behavior: behavior,
        animation: animation,
      ),
    );
  }

  /// Shows a custom dialog with the given [content] and optional parameters.
  Future<T?> showCustomDialog<T>({
    required Widget content,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
    return showDialog<T>(
      context: this,
      builder: (BuildContext context) => content,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
    );
  }

  /// Focus helpers

  /// Unfocuses the current focus scope.
  void unfocus() => focusScope.unfocus();

  /// Navigation helpers

  /// Pops the current route off the navigator.
  void navPop<T>([T? result]) => navigator.pop(result);

  /// Pushes a new route onto the navigator.
  Future<T?> navPush<T>(Widget page) {
    return navigator.push<T>(MaterialPageRoute(builder: (_) => page));
  }

  /// Pushes a named route onto the navigator.
  Future<T?> navPushNamed<T>(String routeName, {Object? arguments}) {
    return navigator.pushNamed<T>(routeName, arguments: arguments);
  }

  /// GoRouter navigation helpers

  /// Pushes a new location onto the GoRouter.
  void goPush(String location) => goRouter.push(location);

  /// Replaces the current location in the GoRouter.
  void goReplace(String location) => goRouter.replace(location);

  /// Provider helpers

  /// Reads a value from a provider without listening to it.
  T read<T>() => Provider.of<T>(this, listen: false);

  /// Watches a value from a provider and rebuilds when it changes.
  T watch<T>() => Provider.of<T>(this);

  /// Responsive helpers

  /// Returns a responsive value based on the current device type.
  double responsiveValue({
    required double mobile,
    required double tablet,
    double? desktop,
  }) {
    if (isPhone) return mobile;
    if (isTablet) return tablet;
    return desktop ?? tablet;
  }

  /// Theme mode helpers

  /// Returns true if the current theme is dark mode.
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Returns true if the current theme is light mode.
  bool get isLightMode => theme.brightness == Brightness.light;

  /// Safe area helpers

  /// Returns the top safe area padding.
  double get safeAreaTop => mediaQuery.padding.top;

  /// Returns the bottom safe area padding.
  double get safeAreaBottom => mediaQuery.padding.bottom;

  /// Returns the left safe area padding.
  double get safeAreaLeft => mediaQuery.padding.left;

  /// Returns the right safe area padding.
  double get safeAreaRight => mediaQuery.padding.right;

  /// Screen size helpers

  /// Returns the current screen size.
  Size get screenSize => mediaQuery.size;

  /// Returns the length of the shortest side of the screen.
  double get shortestSide => screenSize.shortestSide;

  /// Returns the length of the longest side of the screen.
  double get longestSide => screenSize.longestSide;
}
