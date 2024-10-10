import 'package:gahood_portfolio/routes/connecting.dart';
import 'package:gahood_portfolio/routes/disconnected.dart';
import 'package:gahood_portfolio/routes/game.dart';
import 'package:gahood_portfolio/routes/setup.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SetupPage()),
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
