import 'package:flutter/material.dart';
import 'package:gahood_portfolio/routes/routes.dart';

class GahoodApp extends StatelessWidget {
  const GahoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
