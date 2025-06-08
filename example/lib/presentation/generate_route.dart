import 'package:flutter/material.dart';
import 'package:riverpod_app/riverpod_app.dart';

import '../main.dart';

Route<dynamic>? generateRoute(RouteSettings settings) {
  return routeFactories[settings.name]?.call(settings);
}

final routeFactories = <String, RouteFactory>{
  BlankPage.routeName: (settings) =>
      MaterialPageRoute(builder: (_) => const BlankPage()),
  HomePage.routeName: (settings) =>
      MaterialPageRoute(builder: (_) => const HomePage()),
};
