import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_app/riverpod_app.dart';

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
          generateRoute: (_) => MaterialPageRoute(builder: (_) => HomePage()),
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
