import 'package:dart_enet/dart_enet.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahood_portfolio/game/game.dart';
import 'package:go_router/go_router.dart';

// TODO: Should be moved into Game
class _ServerConnectionCubit extends Cubit<String> {
  bool running = true;

  _ServerConnectionCubit() : super("Connecting...");

  void stop() {
    running = false;
  }

  Future<void> start() async {
    final Host host = Host(channelLimit: 1, peerCount: 1);
    final Peer peer = host.connect(Address("127.0.0.1", 1234), 1);
    EnetEvent? event;
    while (running) {
      event = host.service();
      if (event == null) {
        await Future.delayed(const Duration(milliseconds: 20));
        continue;
      }
      if (event is ConnectEvent) {
        emit("Connected!");
      }
    }
    deinitializeEnet();
  }
}

class GamePage extends StatelessWidget {
  final dynamic metadata;

  const GamePage({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _ServerConnectionCubit(),
      child: _GamePage(metadata: metadata),
    );
  }
}

class _GamePage extends StatelessWidget {
  final dynamic metadata;

  const _GamePage({super.key, required this.metadata});

  @override
  Widget build(BuildContext context) {
    if (metadata is! Map<String, Object>) {
      context.go('/');
      return Container();
    }
    final serverConn = context.read<_ServerConnectionCubit>();
    serverConn.start();
    final alias = metadata['alias'] as String?;
    final character = metadata['character'] as int?;
    if (alias == null || character == null) {
      context.go('/');
      return Container();
    }

    return BlocBuilder<_ServerConnectionCubit, String>(
        builder: (context, state) {
      return GameWidget(
        game: GahoodGame(
          alias: alias,
          character: character,
          state: state,
        ),
      );
    });
  }
}
