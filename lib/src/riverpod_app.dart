import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'navigation/state_navigation_observer.dart';

typedef SetupListeners = void Function(ProviderContainer, BuildContext);

class RiverpodApp extends StatefulWidget {
  /// Additional route observers to be added to the navigator.
  final List<RouteObserver<PageRoute<Object?>>>? additionalObserver;

  /// The route generation callback for imperative navigation (classic API).
  final Route<dynamic>? Function(RouteSettings settings)? generateRoute;

  /// Optional callback to set up listeners on the ProviderContainer.
  final SetupListeners? setupListeners;

  /// The Riverpod ProviderContainer used for dependency injection and state management.
  final ProviderContainer container;

  /// Callback to determine the initial route to push after initialization (classic API).
  final Future<String> Function(ProviderContainer ref)? initialRoute;

  /// Whether to hide the flavor banner overlay. Note: the Material debug
  /// banner is always hidden; this controls the custom [Banner] widget that
  /// displays the "flavor" compile-time constant.
  final bool hideBanner;

  /// The main theme for the app.
  final ThemeData theme;

  /// The dark theme for the app (optional).
  final ThemeData? darkTheme;

  /// The title of the app (optional).
  final String? appTitle;

  /// A widget to display as a splash screen during initialization. If null, the native splash remains visible until the first frame.
  final Widget? splashScreen;

  /// The locale for the app (optional).
  final Locale? locale;

  /// The localization delegates for the app (optional).
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// The supported locales for the app (optional).
  final Iterable<Locale>? supportedLocales;

  // Router API support
  /// The RouterDelegate for declarative navigation (Router API).
  final RouterDelegate<Object>? routerDelegate;

  /// The RouteInformationParser for declarative navigation (Router API).
  final RouteInformationParser<Object>? routeInformationParser;

  /// The RouteInformationProvider for declarative navigation (Router API, optional).
  final RouteInformationProvider? routeInformationProvider;

  /// The BackButtonDispatcher for declarative navigation (Router API, optional).
  final BackButtonDispatcher? backButtonDispatcher;

  /// Optional async initialization callback, called before the first screen is shown.
  final Future<void> Function(ProviderContainer)? init;

  /// Optional callback called before setting the initial route.
  final Future<void> Function()? beforeSetInitialRoute;

  /// Optional wrapper for the base app widget, e.g., for adding overlays or global widgets.
  final Widget Function(BuildContext context, Widget)? wrapBaseApp;

  /// Called when [init] or [initialRoute] throws an error. If not provided,
  /// the error is rethrown and the app stays on the splash screen.
  final void Function(Object error, StackTrace stackTrace)? onInitError;

  // Private constructor used by named constructors
  const RiverpodApp._({
    super.key,
    this.additionalObserver,
    this.generateRoute,
    this.setupListeners,
    required this.container,
    required this.theme,
    this.darkTheme,
    this.initialRoute,
    required this.hideBanner,
    this.init,
    this.beforeSetInitialRoute,
    this.wrapBaseApp,
    this.appTitle,
    this.splashScreen,
    this.routerDelegate,
    this.routeInformationParser,
    this.routeInformationProvider,
    this.backButtonDispatcher,
    this.onInitError,
    this.locale,
    this.localizationsDelegates,
    this.supportedLocales,
  });

  /// Classic (imperative) navigation constructor
  factory RiverpodApp.classic({
    Key? key,
    List<RouteObserver<PageRoute<Object?>>>? additionalObserver,
    required Route<dynamic>? Function(RouteSettings settings) generateRoute,
    SetupListeners? setupListeners,
    required ProviderContainer container,
    required ThemeData theme,
    ThemeData? darkTheme,
    required Future<String> Function(ProviderContainer ref) initialRoute,
    required bool hideBanner,
    Future<void> Function(ProviderContainer)? init,
    Future<void> Function()? beforeSetInitialRoute,
    Widget Function(BuildContext context, Widget)? wrapBaseApp,
    String? appTitle,
    Widget? splashScreen,
    void Function(Object error, StackTrace stackTrace)? onInitError,
    Locale? locale,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    Iterable<Locale>? supportedLocales,
  }) {
    return RiverpodApp._(
      key: key,
      additionalObserver: additionalObserver,
      generateRoute: generateRoute,
      setupListeners: setupListeners,
      container: container,
      theme: theme,
      darkTheme: darkTheme,
      initialRoute: initialRoute,
      hideBanner: hideBanner,
      init: init,
      beforeSetInitialRoute: beforeSetInitialRoute,
      wrapBaseApp: wrapBaseApp,
      appTitle: appTitle,
      splashScreen: splashScreen,
      onInitError: onInitError,
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
    );
  }

  /// Declarative (Router API) navigation constructor
  factory RiverpodApp.declarative({
    Key? key,
    required RouterDelegate<Object> routerDelegate,
    required RouteInformationParser<Object> routeInformationParser,
    RouteInformationProvider? routeInformationProvider,
    BackButtonDispatcher? backButtonDispatcher,
    required ProviderContainer container,
    required ThemeData theme,
    ThemeData? darkTheme,
    required bool hideBanner,
    SetupListeners? setupListeners,
    Future<void> Function(ProviderContainer)? init,
    Future<void> Function()? beforeSetInitialRoute,
    Widget Function(BuildContext context, Widget)? wrapBaseApp,
    String? appTitle,
    Widget? splashScreen,
    void Function(Object error, StackTrace stackTrace)? onInitError,
    Locale? locale,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    Iterable<Locale>? supportedLocales,
  }) {
    return RiverpodApp._(
      key: key,
      routerDelegate: routerDelegate,
      routeInformationParser: routeInformationParser,
      routeInformationProvider: routeInformationProvider,
      backButtonDispatcher: backButtonDispatcher,
      container: container,
      theme: theme,
      darkTheme: darkTheme,
      hideBanner: hideBanner,
      setupListeners: setupListeners,
      init: init,
      beforeSetInitialRoute: beforeSetInitialRoute,
      wrapBaseApp: wrapBaseApp,
      appTitle: appTitle,
      splashScreen: splashScreen,
      onInitError: onInitError,
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
    );
  }

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

  @override
  void dispose() {
    defaultNavigatorObserver.currentRouteSubject.close();
    super.dispose();
  }

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
    widget.setupListeners?.call(widget.container, context);
  }

  @override
  Widget build(BuildContext context) {
    return UncontrolledProviderScope(
      container: widget.container,
      child: Consumer(
        builder: (context, ref, _) {
          return Builder(
            builder: (context) {
              final wrap = widget.wrapBaseApp ?? (context, widget) => widget;
              if (widget.routerDelegate != null && widget.routeInformationParser != null) {
                // Use declarative Router API
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: widget.appTitle,
                  theme: widget.theme,
                  darkTheme: widget.darkTheme,
                  themeMode: ThemeMode.system,
                  locale: widget.locale,
                  localizationsDelegates: widget.localizationsDelegates,
                  supportedLocales: widget.supportedLocales ?? const [Locale('en')],
                  routerDelegate: widget.routerDelegate!,
                  routeInformationParser: widget.routeInformationParser!,
                  routeInformationProvider: widget.routeInformationProvider,
                  backButtonDispatcher: widget.backButtonDispatcher,
                  builder: (context, child) => wrap(
                    context,
                    Builder(
                      builder: (context) => _materialAppBuilder(context, child, ref),
                    ),
                  ),
                );
              } else {
                // Use classic imperative navigation
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: widget.appTitle,
                  navigatorKey: _navigatorKey,
                  initialRoute: _SplashOrBlankPage.routeName,
                  theme: widget.theme,
                  darkTheme: widget.darkTheme,
                  themeMode: ThemeMode.system,
                  locale: widget.locale,
                  localizationsDelegates: widget.localizationsDelegates,
                  supportedLocales: widget.supportedLocales ?? const [Locale('en')],
                  onGenerateRoute: (settings) {
                    // Return route provided by usage first
                    final route = widget.generateRoute!(settings);
                    if(route != null) {
                      return route;
                    }
                    // In case of no route provided, we use the splash screen
                    // if the route is the splash screen route.
                    if(settings.name == _SplashOrBlankPage.routeName) {
                      return MaterialPageRoute(
                        builder: (_) => _SplashOrBlankPage(widget.splashScreen),
                      );
                    }
                    // In case of no route provided, we return null
                    // which will cause the app to throw an error.
                    return null;
                  },
                  navigatorObservers: [
                    defaultNavigatorObserver,
                    if (widget.additionalObserver != null)
                      ...widget.additionalObserver!,
                  ],
                  builder: (context, child) => wrap(
                    context,
                    Builder(
                      builder: (context) => _materialAppBuilder(context, child, ref),
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  // The BaseApp initialize the Navigation and Translation for the app.
  Future<void> _initApp() async {
    try {
      final ref = widget.container;
      await widget.init?.call(ref);
      if (!_baseAppSetupCompleter.isCompleted) {
        _baseAppSetupCompleter.complete();
      }
      if (!mounted) return;

      // Declarative mode handles its own routing via RouterDelegate,
      // so we only push the initial route in classic (imperative) mode.
      if (widget.initialRoute != null) {
        final route = await widget.initialRoute!(ref);

        await widget.beforeSetInitialRoute?.call();
        await _navigatorAddedCompleter.future;
        if (!mounted) return;

        unawaited(_navigatorKey.currentState!.pushReplacementNamed(route));
      }

      if (!initDoneCompleter.isCompleted) initDoneCompleter.complete();
    } catch (error, stackTrace) {
      if (widget.onInitError != null) {
        widget.onInitError!(error, stackTrace);
      } else {
        rethrow;
      }
    }
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

class _SplashOrBlankPage extends StatelessWidget {
  static const routeName = '/';
  final Widget? splashScreen;
  const _SplashOrBlankPage(this.splashScreen);

  @override
  Widget build(BuildContext context) {
    if (splashScreen != null) return splashScreen!;
    // Return an empty container so the native splash remains visible
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
