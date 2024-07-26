import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Extension methods for the [Widget] class to enhance functionality and reusability.
extension WidgetExtensions on Widget {
  /// Adds responsive sizing to the widget.
  ///
  /// Uses [ScreenUtilInit] to adapt the widget's size based on the design specifications.
  ///
  /// Parameters:
  /// - [width]: The desired width of the widget.
  /// - [height]: The desired height of the widget.
  /// - [constraints]: Additional constraints to apply to the widget.
  ///
  /// Returns a widget wrapped with responsive sizing capabilities.
  Widget responsive({
    double? width,
    double? height,
    BoxConstraints? constraints,
  }) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => SizedBox(
        width: width?.w,
        height: height?.h,
        child: ConstrainedBox(
          constraints: constraints ?? const BoxConstraints(),
          child: this,
        ),
      ),
    );
  }

  /// Adds a loading state to the widget.
  ///
  /// Overlays a loading indicator on top of the widget when [isLoading] is true.
  ///
  /// Parameters:
  /// - [isLoading]: A boolean indicating whether the loading state should be shown.
  /// - [loadingWidget]: An optional custom widget to display as the loading indicator.
  ///
  /// Returns a widget with loading state functionality.
  Widget withLoadingState({
    required bool isLoading,
    Widget? loadingWidget,
  }) {
    return HookBuilder(
      builder: (context) {
        final opacity = useAnimationController(
          duration: const Duration(milliseconds: 300),
        );

        useEffect(() {
          if (isLoading) {
            opacity.forward();
          } else {
            opacity.reverse();
          }
          return null;
        }, [isLoading]);

        return Stack(
          children: [
            this,
            if (isLoading)
              AnimatedBuilder(
                animation: opacity,
                builder: (context, child) => Opacity(
                  opacity: opacity.value,
                  child: loadingWidget ??
                      const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        );
      },
    );
  }

  /// Adds animation effects to the widget.
  ///
  /// Applies various animation effects such as slide, scale, and fade.
  ///
  /// Parameters:
  /// - [delay]: The delay before the animation starts.
  /// - [animationDuration]: The duration of the animation.
  /// - [curve]: The animation curve to use (default is [Curves.easeInOut]).
  /// - [offset]: The starting offset for the slide effect.
  /// - [scale]: The starting scale for the scale effect.
  /// - [opacity]: The starting opacity for the fade effect.
  ///
  /// Returns an animated version of the widget.
  Widget animate({
    Duration? delay,
    Duration? animationDuration,
    Curve curve = Curves.easeInOut,
    Offset? offset,
    double? scale,
    double? opacity,
  }) {
    return Animate(
      effects: [
        if (offset != null)
          SlideEffect(
            delay: delay,
            duration: animationDuration,
            curve: curve,
            begin: offset,
            end: Offset.zero,
          ),
        if (scale != null)
          ScaleEffect(
            delay: delay,
            duration: animationDuration,
            curve: curve,
            begin: Offset(scale, scale),
            end: const Offset(1.0, 1.0),
          ),
        if (opacity != null)
          FadeEffect(
            delay: delay,
            duration: animationDuration,
            curve: curve,
            begin: opacity,
            end: 1.0,
          ),
      ],
      child: this,
    );
  }

  /// Adds dependency injection to the widget.
  ///
  /// Retrieves a dependency of type [T] from GetIt and passes it to the [builder] function.
  ///
  /// Parameters:
  /// - [builder]: A function that takes the build context and the injected dependency,
  ///   and returns a widget.
  ///
  /// Returns a widget with the injected dependency.
  Widget withDependency<T extends Object>({
    required Widget Function(BuildContext context, T dependency) builder,
  }) {
    return Builder(
      builder: (context) {
        final dependency = GetIt.I<T>();
        return builder(context, dependency);
      },
    );
  }

  /// Adds navigation capabilities to the widget.
  ///
  /// Wraps the widget with a [GestureDetector] that triggers the provided [onTap] function
  /// when tapped, passing the current navigation context.
  ///
  /// Parameters:
  /// - [onTap]: A function to be called when the widget is tapped, receiving the current context.
  ///
  /// Returns a tappable widget with navigation capabilities.
  Widget onTap(void Function(BuildContext context) onTap) {
    return GestureDetector(
      onTap: () => onTap(GetIt.I<StackRouter>().navigatorKey.currentContext!),
      child: this,
    );
  }

  /// Adds a hero animation to the widget.
  ///
  /// Wraps the widget with a [Hero] widget for seamless transitions between screens.
  ///
  /// Parameters:
  /// - [tag]: A unique identifier for the hero animation.
  ///
  /// Returns a widget wrapped with hero animation capabilities.
  Widget withHero(String tag) {
    return Hero(
      tag: tag,
      child: this,
    );
  }
}
