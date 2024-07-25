import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:hcd/utils/utils.dart';

extension BuildContextExtensions on BuildContext {
  // Theme related
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  // Media query related
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get screenWidth => mediaQuery.size.width;
  double get screenHeight => mediaQuery.size.height;
  EdgeInsets get padding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  bool get isKeyboardVisible => mediaQuery.viewInsets.bottom > 0;
  Orientation get orientation => mediaQuery.orientation;
  bool get isLandscape => orientation == Orientation.landscape;
  bool get isPortrait => orientation == Orientation.portrait;

  // Device related
  bool get isTablet => screenWidth > 600;
  bool get isPhone => screenWidth <= 600;

  // Navigation related
  NavigatorState get navigator => Navigator.of(this);
  GoRouter get goRouter => GoRouter.of(this);

  // Other common widgets
  FocusScopeNode get focusScope => FocusScope.of(this);
  ScaffoldState get scaffold => Scaffold.of(this);
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  // Snackbar and dialog helpers
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

  // Focus helpers
  void unfocus() => focusScope.unfocus();

  // Navigation helpers
  void navPop<T>([T? result]) => navigator.pop(result);

  Future<T?> navPush<T>(Widget page) {
    return navigator.push<T>(MaterialPageRoute(builder: (_) => page));
  }

  Future<T?> navPushNamed<T>(String routeName, {Object? arguments}) {
    return navigator.pushNamed<T>(routeName, arguments: arguments);
  }

  // GoRouter navigation helpers
  void goPush(String location) => goRouter.push(location);
  void goReplace(String location) => goRouter.replace(location);

  // Provider helpers
  T read<T>() => Provider.of<T>(this, listen: false);
  T watch<T>() => Provider.of<T>(this);

  // Responsive helpers
  double responsiveValue({
    required double mobile,
    required double tablet,
    double? desktop,
  }) {
    if (isPhone) return mobile;
    if (isTablet) return tablet;
    return desktop ?? tablet;
  }

  // Theme mode helpers
  bool get isDarkMode => theme.brightness == Brightness.dark;
  bool get isLightMode => theme.brightness == Brightness.light;

  // Safe area helpers
  double get safeAreaTop => mediaQuery.padding.top;
  double get safeAreaBottom => mediaQuery.padding.bottom;
  double get safeAreaLeft => mediaQuery.padding.left;
  double get safeAreaRight => mediaQuery.padding.right;

  // Screen size helpers
  Size get screenSize => mediaQuery.size;
  double get shortestSide => screenSize.shortestSide;
  double get longestSide => screenSize.longestSide;
}
