import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahood_portfolio/game/components/direction.dart';

abstract class PlayerInput extends Equatable {
  const PlayerInput();
}

class PlayerNoInput extends PlayerInput {
  const PlayerNoInput();

  @override
  List<Object?> get props => [];
}

class PlayerMovementInput extends PlayerInput {
  final Direction direction;

  const PlayerMovementInput({required this.direction});

  @override
  List<Object?> get props => [direction];
}

class PlayerActionInput extends PlayerInput {
  const PlayerActionInput();

  @override
  List<Object?> get props => [];
}

class PlayerInputCubit extends Cubit<PlayerInput> {
  static final Set<LogicalKeyboardKey> _arrowKeys = {
    LogicalKeyboardKey.keyW,
    LogicalKeyboardKey.keyA,
    LogicalKeyboardKey.keyS,
    LogicalKeyboardKey.keyD,
    LogicalKeyboardKey.arrowUp,
    LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.arrowLeft,
    LogicalKeyboardKey.arrowRight,
  };
  static final Set<LogicalKeyboardKey> _actionKeys = {
    LogicalKeyboardKey.space,
    LogicalKeyboardKey.enter,
  };
  final List<LogicalKeyboardKey> _directionKeysDown = [];

  PlayerInputCubit({
    required KeyDownCubit keyDownCubit,
    required KeyUpCubit keyUpCubit,
  }) : super(const PlayerNoInput()) {
    keyDownCubit.stream.listen(_onKeyDown);
    keyUpCubit.stream.listen(_onKeyUp);
  }

  void _onKeyUp(LogicalKeyboardKey? key) {
    if (key == null) {
      emit(const PlayerNoInput());
      return;
    }
    if (_arrowKeys.contains(key)) {
      _directionKeysDown.remove(key);
    }
    if (_directionKeysDown.isNotEmpty) {
      final nextKey = _directionKeysDown.last;
      final direction = Direction.fromKey(nextKey);
      emit(PlayerMovementInput(direction: direction!));
    } else {
      emit(const PlayerNoInput());
    }
  }

  void _onKeyDown(LogicalKeyboardKey? key) {
    if (_arrowKeys.contains(key)) {
      final direction = Direction.fromKey(key);
      _directionKeysDown.remove(key);
      _directionKeysDown.add(key!);
      emit(PlayerMovementInput(direction: direction!));
    } else if (_actionKeys.contains(key)) {
      emit(const PlayerActionInput());
    } else {
      emit(const PlayerNoInput());
    }
  }
}

class KeyDownCubit extends Cubit<LogicalKeyboardKey?> {
  KeyDownCubit() : super(null);

  void update(LogicalKeyboardKey key) {
    emit(null);
    emit(key);
  }
}

class KeyUpCubit extends Cubit<LogicalKeyboardKey?> {
  KeyUpCubit() : super(null);

  void update(LogicalKeyboardKey key) {
    emit(null);
    emit(key);
  }
}
