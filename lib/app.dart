import 'package:flutter/material.dart';
import 'package:gahood_portfolio/routes/routes.dart';

class GahoodApp extends StatelessWidget {
  const GahoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Adam Charlton\'s Portfolio',
      routerConfig: router,
    );
  }
}
