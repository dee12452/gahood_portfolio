import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahood_portfolio/game/connection.dart';
import 'package:gahood_portfolio/game/game.dart';
import 'package:gahood_portfolio/game/state.dart';
import 'package:gahood_portfolio/widgets/chatbox.dart';
import 'package:go_router/go_router.dart';

class ChatBoxToggleCubit extends Cubit<bool> {
  ChatBoxToggleCubit() : super(true);

  void toggle() {
    emit(!state);
  }
}

class GamePage extends StatelessWidget {
  final dynamic metadata;

  const GamePage({required this.metadata});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ChatBoxToggleCubit()),
      ],
      child: Scaffold(
        body: _GamePage(metadata: metadata),
      ),
    );
  }
}

class _GamePage extends StatelessWidget {
  final dynamic metadata;
  final FocusNode gameFocus = FocusNode();
  final FocusNode chatFocus = FocusNode();

  _GamePage({required this.metadata});

  @override
  Widget build(BuildContext context) {
    if (metadata is! Map<String, Object>) {
      context.go('/');
      return Container();
    }
    final alias = metadata['alias'] as String?;
    final character = metadata['character'] as int?;
    // TODO: Do we need a server?
    final client = metadata['client'] as Connection?;
    client?.disconnect();
    if (character == null) {
      context.go('/');
      return Container();
    }

    final chatBoxCubit = context.read<ChatBoxToggleCubit>();
    final game = GahoodGame(
      alias: alias,
      character: character,
      exitGame: () => context.go('/portfolio'),
      openBotOverlay: chatBoxCubit.toggle,
    );
    return Stack(
      children: [
        GameWidget(
          game: game,
          focusNode: gameFocus,
        ),
        BlocBuilder<ChatBoxToggleCubit, bool>(
          builder: (context, state) {
            if (!state) {
              return Container();
            }
            return ChatBox(
              focusNode: chatFocus,
              onClose: () {
                chatBoxCubit.toggle();
                game.state = GameState.play;
                chatFocus.unfocus();
                gameFocus.requestFocus();
              },
            );
          },
        ),
      ],
    );
  }
}
