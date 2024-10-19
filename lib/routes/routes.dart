import 'package:flutter/foundation.dart';
import 'package:gahood_portfolio/routes/connecting.dart';
import 'package:gahood_portfolio/routes/disconnected.dart';
import 'package:gahood_portfolio/routes/game.dart';
import 'package:gahood_portfolio/routes/portfolio.dart';
import 'package:gahood_portfolio/routes/setup.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: _determineInitialRoute(),
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SetupPage()),
    GoRoute(path: '/portfolio', builder: (context, state) => PortfolioPage()),
    GoRoute(
      path: '/connecting',
      builder: (context, state) => ConnectingPage(metadata: state.extra),
    ),
    GoRoute(
      path: '/disconnected',
      builder: (context, state) => const DisconnectedPage(),
    ),
    GoRoute(
      path: '/game',
      builder: (context, state) => GamePage(
        metadata: state.extra,
      ),
    ),
  ],
);

String _determineInitialRoute() {
  if (!kIsWeb) {
    return '/';
  }
  if ([TargetPlatform.iOS, TargetPlatform.android]
      .contains(defaultTargetPlatform)) {
    return '/portfolio';
  } else {
    return '/';
  }
}
