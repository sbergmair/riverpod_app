import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

/// ⚠️ We always need to set the [_currentRoute] before doing the super call,
/// since the state should be correct when using the [StateNavigationObserver] in other classes.
class StateNavigationObserver extends RouteObserver<Route<Object?>> {
  final currentRouteSubject = BehaviorSubject<Route<Object?>?>();

  Route<Object?>? get currentRoute => currentRouteSubject.value;

  @override
  // https://api.flutter.dev/flutter/widgets/RouteObserver/didPop.html
  /// "The route immediately below that one, and thus the newly active route, is previousRoute."
  void didPop(Route<Object?> route, Route<Object?>? previousRoute) {
    currentRouteSubject.add(previousRoute);
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route<Object?> route, Route<Object?>? previousRoute) {
    currentRouteSubject.add(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didRemove(Route<Object?> route, Route<Object?>? previousRoute) {
    currentRouteSubject.add(previousRoute);
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route<Object?>? newRoute, Route<Object?>? oldRoute}) {
    currentRouteSubject.add(newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didChangeTop(Route<Object?> topRoute, Route<Object?>? previousTopRoute) {
    currentRouteSubject.add(topRoute);
    super.didChangeTop(topRoute, previousTopRoute);
  }
}