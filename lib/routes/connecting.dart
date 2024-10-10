import 'dart:async';
import 'dart:convert';

import 'package:dart_enet/dart_enet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahood_portfolio/game/connection.dart';
import 'package:go_router/go_router.dart';

class _ConnectingTextCubit extends Cubit<String> {
  Timer? timer;
  int periods = 0;

  _ConnectingTextCubit() : super('Connecting') {
    timer =
        Timer.periodic(const Duration(milliseconds: 500), (_) => emit(next));
  }

  @override
  Future<void> close() {
    timer?.cancel();
    return super.close();
  }

  String get next {
    periods++;
    if (periods > 3) {
      periods = 0;
    }
    return 'Connecting${'.' * periods}';
  }
}

class _ClientConnectionCubit extends Cubit<Connection?> {
  _ClientConnectionCubit() : super(null);

  Future<void> connect() async {
    final Host host = Host(channelLimit: 1, peerCount: 1);
    host.connect(Address('127.0.0.1', 1234), 1);
    EnetEvent? event;
    while (true) {
      await Future.delayed(const Duration(milliseconds: 500));
      event = host.service();
      if (event is! ConnectEvent) {
        continue;
      }
      emit(Connection(host: host, peer: event.peer));
      break;
    }
  }
}

class ConnectingPage extends StatelessWidget {
  final dynamic metadata;

  const ConnectingPage({required this.metadata});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => _ConnectingTextCubit()),
          BlocProvider(create: (_) => _ClientConnectionCubit()),
        ],
        child: _ConnectingPage(
          metadata: metadata,
        ),
      ),
    );
  }
}

class _ConnectingPage extends StatelessWidget {
  final Map<String, dynamic> metadata;

  const _ConnectingPage({required this.metadata});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final connectionCubit = context.read<_ClientConnectionCubit>();
    connectionCubit.connect();
    return BlocListener<_ClientConnectionCubit, Connection?>(
      listener: (conext, connection) {
        if (connection != null) {
          metadata['client'] = connection;
          context.go(
            '/game',
            extra: metadata,
          );
        }
      },
      child: BlocBuilder<_ConnectingTextCubit, String>(
        builder: (context, state) {
          return Center(
            child: Text(
              state,
              style:
                  TextStyle(fontSize: size.height * 0.1, color: Colors.white70),
            ),
          );
        },
      ),
    );
  }
}
