import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverpodApp extends StatefulWidget {
  final List<RouteObserver<PageRoute<Object?>>>? additionalObserver;
  final Route<dynamic>? Function(RouteSettings settings) generateRoute;
  final void Function(ProviderContainer)? setupListeners;
  final ProviderContainer container;
  final String? initialRoute;
  final bool hideBanner;

  final Future<void> Function(ProviderContainer)? init;
  final Future<void> Function()? beforeSetInitialRoute;
  final Widget Function(BuildContext context, Widget)? wrapBaseApp;

  const RiverpodApp({
    super.key,
    this.additionalObserver,
    required this.generateRoute,
    this.setupListeners,
    required this.container,
    this.initialRoute,
    required this.hideBanner,
    this.init,
    this.beforeSetInitialRoute,
    this.wrapBaseApp,
  });

  @override
  State<RiverpodApp> createState() => _RiverpodAppState();
}

class _RiverpodAppState extends State<RiverpodApp> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
