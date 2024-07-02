import '../linker.dart';

extension WidgetExtension on Widget? {
  Future<T?> launch<T>(BuildContext context,
      {bool isNewTask = false,
      PageRouteAnimation? pageRouteAnimation,
      Duration? duration}) async {
    if (isNewTask) {
      return await Navigator.of(context).pushAndRemoveUntil(
        buildPageRoute(
            this!, pageRouteAnimation ?? pageRouteAnimationGlobal, duration),
        (route) => false,
      );
    } else {
      return await Navigator.of(context).push(
        buildPageRoute(
            this!, pageRouteAnimation ?? pageRouteAnimationGlobal, duration),
      );
    }
  }

  /// Builds a page route with the specified animation.
  Route<T> buildPageRoute<T>(
    Widget child,
    PageRouteAnimation? pageRouteAnimation,
    Duration? duration,
  ) {
    if (pageRouteAnimation != null) {
      if (pageRouteAnimation == PageRouteAnimation.Fade) {
        // Fade animation for page route.
        return PageRouteBuilder(
          pageBuilder: (c, a1, a2) => child,
          transitionsBuilder: (c, anim, a2, child) {
            return FadeTransition(opacity: anim, child: child);
          },
          transitionDuration: duration ?? pageRouteTransitionDurationGlobal,
        );
      } else if (pageRouteAnimation == PageRouteAnimation.Rotate) {
        // Rotation animation for page route.
        return PageRouteBuilder(
          pageBuilder: (c, a1, a2) => child,
          transitionsBuilder: (c, anim, a2, child) {
            return RotationTransition(
                child: child, turns: ReverseAnimation(anim));
          },
          transitionDuration: duration ?? pageRouteTransitionDurationGlobal,
        );
      } else if (pageRouteAnimation == PageRouteAnimation.Scale) {
        // Scale animation for page route.
        return PageRouteBuilder(
          pageBuilder: (c, a1, a2) => child,
          transitionsBuilder: (c, anim, a2, child) {
            return ScaleTransition(child: child, scale: anim);
          },
          transitionDuration: duration ?? pageRouteTransitionDurationGlobal,
        );
      } else if (pageRouteAnimation == PageRouteAnimation.Slide) {
        // Slide animation for page route.
        return PageRouteBuilder(
          pageBuilder: (c, a1, a2) => child,
          transitionsBuilder: (c, anim, a2, child) {
            return SlideTransition(
              child: child,
              position: Tween(
                begin: Offset(1.0, 0.0),
                end: Offset(0.0, 0.0),
              ).animate(anim),
            );
          },
          transitionDuration: duration ?? pageRouteTransitionDurationGlobal,
        );
      } else if (pageRouteAnimation == PageRouteAnimation.SlideBottomTop) {
        // Slide from bottom to top animation for page route.
        return PageRouteBuilder(
          pageBuilder: (c, a1, a2) => child,
          transitionsBuilder: (c, anim, a2, child) {
            return SlideTransition(
              child: child,
              position: Tween(
                begin: Offset(0.0, 1.0),
                end: Offset(0.0, 0.0),
              ).animate(anim),
            );
          },
          transitionDuration: duration ?? pageRouteTransitionDurationGlobal,
        );
      }
    }
    // Default page route.
    return MaterialPageRoute<T>(builder: (_) => child);
  }
}

extension IntExtensions on int? {
  int validate({int value = 0}) {
    return this ?? value;
  }

  Widget get height => SizedBox(height: this?.toDouble());
  Widget get width => SizedBox(width: this?.toDouble());
  Duration get milliseconds => Duration(milliseconds: validate());
}

// Context Extensions
extension ContextExtensions on BuildContext {
  /// return screen size
  Size size() => MediaQuery.of(this).size;

  /// return screen width
  double width() => maxScreenWidth ?? MediaQuery.of(this).size.width;

  /// return screen height
  double height() => MediaQuery.of(this).size.height;

  close() => Navigator.pop(this);
}
