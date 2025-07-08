import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod_app.dart';
import 'navigation/state_navigation_observer.dart';

class RiverpodApp extends StatefulWidget {
  final List<RouteObserver<PageRoute<Object?>>>? additionalObserver;
  final Route<dynamic>? Function(RouteSettings settings) generateRoute;
  final void Function(ProviderContainer)? setupListeners;
  final ProviderContainer container;
  final Future<String> Function(ProviderContainer ref) initialRoute;
  final bool hideBanner;
  final ThemeData theme;
  final ThemeData? darkThem;
  final String? appTitle;

  final Future<void> Function(ProviderContainer)? init;
  final Future<void> Function()? beforeSetInitialRoute;
  final Widget Function(BuildContext context, Widget)? wrapBaseApp;

  const RiverpodApp({
    super.key,
    this.additionalObserver,
    required this.generateRoute,
    this.setupListeners,
    required this.container,
    required this.theme,
    this.darkThem,
    required this.initialRoute,
    required this.hideBanner,
    this.init,
    this.beforeSetInitialRoute,
    this.wrapBaseApp,
    this.appTitle,
  });

  @override
  State<RiverpodApp> createState() => RiverpodAppState();

  static RiverpodAppState of(BuildContext context) {
    return context.findAncestorStateOfType<RiverpodAppState>()!;
  }
}

class RiverpodAppState extends State<RiverpodApp> {
  final _navigatorKey = GlobalKey<NavigatorState>(
    debugLabel: "RiverpodAppNavigatorKey",
  );
  final defaultNavigatorObserver = StateNavigationObserver();

  NavigatorState get navigator => _navigatorKey.currentState!;

  @visibleForTesting
  final initDoneCompleter = Completer<void>();

  /// Completer that completes when the setup of the base app is done.
  /// This means [widget.init] is done.
  final _baseAppSetupCompleter = Completer<void>();

  /// This completer is used to wait until the navigator was added into the
  /// tree so we can use this navigator to push the initial route.
  final _navigatorAddedCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();
    _initApp();
    // Important to setup listeners of [ProviderContainer] in initState.
    // Otherwise the listeners trigger multiple times for each instance.
    // This works differently here than with [WidgetRef].
    widget.setupListeners?.call(widget.container);
  }

  @override
  Widget build(BuildContext context) {
    return UncontrolledProviderScope(
      container: widget.container,
      child: Consumer(
        builder: (context, ref, _) {
          return Builder(
            builder: (context) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: widget.appTitle,
                navigatorKey: _navigatorKey,
                initialRoute: BlankPage.routeName,
                theme: widget.theme,
                darkTheme: widget.darkThem,
                themeMode: ThemeMode.system,
                onGenerateRoute: widget.generateRoute,
                navigatorObservers: [
                  defaultNavigatorObserver,
                  if (widget.additionalObserver != null)
                    ...widget.additionalObserver!,
                ],
                builder: (_, child) {
                  final wrap =
                      widget.wrapBaseApp ?? (context, widget) => widget;

                  return wrap(
                    context,
                    Builder(
                      builder: (context) =>
                          _materialAppBuilder(context, child, ref),
                    ),
                  );
                },
                // locale: _deviceOverrideLocale,
                // supportedLocales: AppLocalization.supportedLocales,
                // localeListResolutionCallback:
                // AppLocalization.localeListResolutionCallback,
                // localizationsDelegates: localizationsDelegates,
              );
            },
          );
        },
      ),
    );
  }

  // The BaseApp initialize the Navigation and Translation for the app.
  Future<void> _initApp() async {
    final ref = widget.container;
    await widget.init?.call(ref);
    if (!_baseAppSetupCompleter.isCompleted) _baseAppSetupCompleter.complete();
    if (!mounted) return;

    final route = await widget.initialRoute(ref);

    await widget.beforeSetInitialRoute?.call();
    await _navigatorAddedCompleter.future;
    if (!mounted) return;

    unawaited(_navigatorKey.currentState!.pushReplacementNamed(route));

    initDoneCompleter.complete();
  }

  Widget _materialAppBuilder(
    BuildContext context,
    Widget? child,
    WidgetRef ref,
  ) {
    final mediaQuery = MediaQuery.of(context);

    // the builder will be called avery time when the device brightness changes, so we don't need to listen to any additional changes
    return MediaQuery(
      data: mediaQuery.copyWith(
        boldText: false,
        textScaler: mediaQuery.textScaler.clamp(maxScaleFactor: 1.5),
      ),
      child: Builder(
        builder: (context) {
          final finalWidget = _InitCallback(
            onInitialize: () {
              // When changing any properties in the MaterialApp
              // we might rebuild the entire sub tree (finalWidget) which
              // will cause this callback to be executed again.
              // This would cause the completer to complete twice.
              if (_navigatorAddedCompleter.isCompleted) return;
              _navigatorAddedCompleter.complete();
            },
            child: child!,
          );

          if (widget.hideBanner) {
            return finalWidget;
          }

          // We are clipping since the banner draws outside of the App
          // which is visible when the App is moved into the minimized feedback view.
          return ClipRect(
            child: Banner(
              message: String.fromEnvironment("flavor"),
              location: BannerLocation.topEnd,
              color: Theme.of(context).primaryColor,
              child: finalWidget,
            ),
          );
        },
      ),
    );
  }
}

class _InitCallback extends StatefulWidget {
  final Widget child;
  final VoidCallback onInitialize;

  const _InitCallback({required this.child, required this.onInitialize});

  @override
  State<_InitCallback> createState() => _InitCallbackState();
}

class _InitCallbackState extends State<_InitCallback> {
  @override
  void initState() {
    super.initState();
    widget.onInitialize();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
