import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahood_portfolio/routes/game.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class _ChatMessage extends Equatable {
  final bool ai;
  final String message;

  const _ChatMessage({required this.ai, required this.message});

  @override
  List<Object?> get props => [ai, message];
}

class _ChatState extends Equatable {
  final bool connected;
  final List<_ChatMessage> messages;
  final bool waitingForReply;

  const _ChatState({
    required this.connected,
    required this.messages,
    this.waitingForReply = true,
  });

  @override
  List<Object?> get props => [connected, messages, waitingForReply];
}

class _ChatBoxCubit extends Cubit<_ChatState> {
  static final Uri _serverUrl = Uri.parse('ws://api.ai.gahood.io');
  WebSocketChannel? channel;

  _ChatBoxCubit() : super(const _ChatState(connected: false, messages: []));

  Future<void> load() async {
    final messages = List.of(state.messages);
    messages.add(const _ChatMessage(ai: true, message: 'Connecting...'));
    emit(_ChatState(connected: false, messages: messages));

    channel = WebSocketChannel.connect(_serverUrl);
    if (channel == null) {
      messages.add(
        const _ChatMessage(
          ai: true,
          message:
              'Unable to connect. AI service is currently down. Please try again later.',
        ),
      );
      emit(_ChatState(connected: false, messages: messages));
      return;
    }

    await channel!.ready;
    messages.add(
      const _ChatMessage(
        ai: true,
        message: 'Connected. Go ahead and ask a question about Adam!',
      ),
    );
    emit(
      _ChatState(
        connected: true,
        messages: messages,
        waitingForReply: false,
      ),
    );
    channel!.stream.listen(
      (message) {
        final allMessages = List.of(state.messages);
        allMessages.add(
          _ChatMessage(
            ai: true,
            message: message,
          ),
        );
        emit(
          _ChatState(
            connected: true,
            messages: allMessages,
            waitingForReply: false,
          ),
        );
      },
      onError: (error) {
        final allMessages = List.of(state.messages);
        allMessages.add(
          const _ChatMessage(
            ai: true,
            message:
                'An error has occurred and the connection has been closed. Please try again later.',
          ),
        );
        emit(_ChatState(connected: false, messages: allMessages));
      },
    );
  }

  Future<void> send(String message) async {
    if (!state.connected ||
        channel == null ||
        state.waitingForReply ||
        message == '') {
      return;
    }

    final messages = List.of(state.messages);
    if (message.length > 100) {
      messages.add(
        const _ChatMessage(
          ai: true,
          message:
              'Prompts have a max length of 100 characters. Please try a shorter question.',
        ),
      );
      emit(_ChatState(connected: state.connected, messages: messages));
      return;
    }

    messages.add(_ChatMessage(ai: false, message: message));
    emit(_ChatState(connected: state.connected, messages: messages));
    channel!.sink.add(message);
  }

  void disconnect() {
    if (channel != null) {
      channel!.sink.close(1000);
    }
  }
}

class ChatBox extends StatelessWidget {
  final Function onClose;
  final FocusNode focusNode;

  const ChatBox({
    required this.onClose,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _ChatBoxCubit()),
      ],
      child: _ChatBox(
        onClose: onClose,
        focusNode: focusNode,
      ),
    );
  }
}

class _ChatBox extends StatelessWidget {
  final Function onClose;
  final FocusNode focusNode;
  final TextEditingController _controller = TextEditingController();

  _ChatBox({
    required this.onClose,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final toggleCubit = context.read<ChatBoxToggleCubit>();
    final chatCubit = context.read<_ChatBoxCubit>();
    chatCubit.load();
    return BlocBuilder<_ChatBoxCubit, _ChatState>(
      builder: (context, state) {
        final messages = state.messages;
        return Container(
          color: Colors.black87,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length + (state.waitingForReply ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < messages.length) {
                      final bool isAi = messages[index].ai;
                      final message = isAi
                          ? messages[index].message
                          : 'You: ${messages[index].message}';
                      final textColor =
                          isAi ? Colors.greenAccent : Colors.white;
                      return ListTile(
                        title: Text(
                          message,
                          style: TextStyle(color: textColor),
                        ),
                      );
                    } else {
                      return const ListTile(
                        title: Text(
                          '...',
                          style: TextStyle(color: Colors.greenAccent),
                        ),
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: focusNode,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Ask a question',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (value) {
                          if (state.waitingForReply) {
                            return;
                          }
                          _controller.clear();
                          chatCubit.send(value);
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (state.waitingForReply) {
                          return;
                        }
                        final playerMessage = _controller.text;
                        _controller.clear();
                        chatCubit.send(playerMessage);
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        chatCubit.disconnect();
                        FocusScope.of(context).unfocus();
                        _controller.clear();
                        onClose();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
