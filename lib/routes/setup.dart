import 'package:flame/game.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class _AliasCubit extends Cubit<String> {
  _AliasCubit() : super('');

  set text(String text) => emit(text);
}

class _CharacterSelectCubit extends Cubit<int> {
  static const int _min = 1;
  static const int _max = 1;

  _CharacterSelectCubit() : super(_min);

  void toggleLeft() {
    final next = state - 1;
    if (next < _min) {
      emit(_max);
    } else {
      emit(next);
    }
  }

  void toggleRight() {
    final next = state + 1;
    if (next > _max) {
      emit(_min);
    } else {
      emit(next);
    }
  }
}

class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _AliasCubit()),
        BlocProvider(create: (context) => _CharacterSelectCubit()),
      ],
      child: _SetupPage(),
    );
  }
}

class _SetupPage extends StatelessWidget {
  final TextEditingController _aliasController = TextEditingController();

  _SetupPage();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final aliasCubit = context.read<_AliasCubit>();
    final characterSelectCubit = context.read<_CharacterSelectCubit>();
    _aliasController.addListener(() => aliasCubit.text = _aliasController.text);
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to',
              style: TextStyle(
                fontSize: 16.0, // Set font size for the title
                fontWeight: FontWeight.bold, // Make the text bold
                color: Colors.white70, // Set text color
              ),
            ),
            const Text(
              'Adam Charlton\'s Portfolio',
              style: TextStyle(
                fontSize: 32.0, // Set font size for the title
                fontWeight: FontWeight.bold, // Make the text bold
                color: Colors.white70, // Set text color
              ),
            ),
            SizedBox(
              height: height * 0.1,
            ),
            SizedBox(
              width: width * 0.5,
              child: TextField(
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(), // Adds an outlined border
                  hintText: 'Enter an alias', // Hint text
                  fillColor: Colors.white70,
                  filled: true,
                ),
                controller: _aliasController,
              ),
            ),
            SizedBox(
              height: height * 0.1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: characterSelectCubit.toggleLeft,
                  child: const Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.arrow_left,
                      color: Colors.white70,
                    ),
                  ),
                ),
                BlocBuilder<_CharacterSelectCubit, int>(
                  builder: (context, state) => SizedBox(
                    height: height * 0.075,
                    child: SpriteWidget.asset(
                      path: 'character_${state}_idle.png',
                      srcSize: Vector2(32, 48),
                      loadingBuilder: (context) =>
                          const CircularProgressIndicator(),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: characterSelectCubit.toggleRight,
                  child: const Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.arrow_right,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.02,
            ),
            const Text(
              'Select Character',
              style: TextStyle(
                fontSize: 14.0, // Set font size for the title
                fontWeight: FontWeight.bold, // Make the text bold
                color: Colors.white70, // Set text color
              ),
            ),
            SizedBox(
              height: height * 0.1,
            ),
            BlocBuilder<_AliasCubit, String>(
              builder: (context, state) => ElevatedButton(
                onPressed: state == ''
                    ? () {}
                    : () {
                        context.go(
                          '/game',
                          extra: {
                            'alias': state,
                            'character': characterSelectCubit.state,
                          },
                        );
                      },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // Rounded edges
                  ),
                  foregroundColor: state == '' ? Colors.grey : Colors.blue,
                ),
                child: const Text('Play'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
