import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:gahood_portfolio/game/connection.dart';
import 'package:gahood_portfolio/game/game.dart';
import 'package:go_router/go_router.dart';

class GamePage extends StatelessWidget {
  final dynamic metadata;

  const GamePage({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    if (metadata is! Map<String, Object>) {
      context.go('/');
      return Container();
    }
    final alias = metadata['alias'] as String?;
    final character = metadata['character'] as int?;
    final client = metadata['client'] as Connection?;
    if (alias == null || character == null || client == null) {
      context.go('/');
      return Container();
    }

    return GameWidget(
      game: GahoodGame(
        alias: alias,
        character: character,
        connection: client,
      ),
    );
  }
}
