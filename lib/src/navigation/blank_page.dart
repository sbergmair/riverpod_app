import 'package:flutter/material.dart';

class BlankPage extends StatelessWidget {
  static const routeName = "/blank";

  const BlankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}