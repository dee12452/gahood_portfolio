import 'package:gahood_portfolio/routes/game.dart';
import 'package:gahood_portfolio/routes/setup.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => const SetupPage()),
  GoRoute(
    path: '/game',
    builder: (context, state) => GamePage(
      metadata: state.extra,
    ),
  ),
]);
