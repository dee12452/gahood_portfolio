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
  static const int _max = 20;

  _CharacterSelectCubit() : super(0);

  void toggleLeft() {
    if (state == 0) {
      emit(_max - 1);
    }
    emit(state - 1);
  }

  void toggleRight() {
    if (state == _max - 1) {
      emit(0);
    }
    emit(state + 1);
  }
}

class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (_) => _AliasCubit()),
      BlocProvider(create: (context) => _CharacterSelectCubit()),
    ], child: _SetupPage());
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
                    width: height * 0.075,
                    child: SpriteWidget.asset(
                      path: 'characters.png',
                      srcPosition: Vector2(0, state * 16),
                      srcSize: Vector2(16, 16),
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
                        context.go('/game', extra: {
                          'alias': state,
                          'character': characterSelectCubit.state,
                        });
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
