import 'package:flutter_riverpod/flutter_riverpod.dart';

final provInit = FutureProvider<String>((ref) async {
  await Future<void>.delayed(const Duration(seconds: 2));
  return "Init done";
});
