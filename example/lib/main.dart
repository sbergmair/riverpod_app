import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_app/riverpod_app.dart';
import 'package:riverpod_app_example/presentation/generate_route.dart';
import 'package:riverpod_app_example/provider.dart';

Future<void> main() async {
  final appKey = GlobalKey<RiverpodAppState>();
  ProviderContainer? container;

  await runZonedGuarded(
    () async {
      // This will initialize the "WidgetsFlutterBinding" and the sentry binding.
      WidgetsFlutterBinding.ensureInitialized();

      container = ProviderContainer();
      runApp(
        RiverpodApp(
          key: appKey,
          container: container!,
          generateRoute: generateRoute,
          theme: ThemeData.light(),
          initialRoute: (_) async => "/home",
          hideBanner: false,
        ),
      );
    },
    (error, stack) async {
      debugPrint("$error");
      debugPrintStack(stackTrace: stack);
    },
  );
}

class HomePage extends ConsumerStatefulWidget {
  static const routeName = "/home";

  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final init = ref.watch(provInit);

    return Scaffold(
      body: Center(
        child: switch (init) {
          AsyncError(:final error) => Text('Error: $error'),
          AsyncData(:final value) => Text(value),
          _ => const CircularProgressIndicator(),
        },
      ),
    );

    return Scaffold(body: Center(child: Text("HomePage")));
  }
}
