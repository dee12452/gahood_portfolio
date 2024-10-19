import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gahood_portfolio/game/components/object.dart';
import 'package:gahood_portfolio/game/components/player.dart';
import 'package:gahood_portfolio/game/components/wall.dart';
import 'package:gahood_portfolio/game/input.dart';

class GahoodWorld extends World with HasCollisionDetection {
  final CameraComponent camera;
  final Player player;
  final ObjectFactory factory;
  final KeyUpCubit keyUpCubit;
  final KeyDownCubit keyDownCubit;
  late final TiledComponent map;

  GahoodWorld({
    required this.camera,
    required this.player,
    required this.keyUpCubit,
    required this.keyDownCubit,
    this.factory = const ObjectFactory(),
  });

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    final components = await _loadMap();
    components.add(player);

    final blocProviders = FlameMultiBlocProvider(
      providers: [
        FlameBlocProvider<KeyDownCubit, LogicalKeyboardKey?>(
          create: () => keyDownCubit,
        ),
        FlameBlocProvider<KeyUpCubit, LogicalKeyboardKey?>(
          create: () => keyUpCubit,
        ),
        FlameBlocProvider<PlayerInputCubit, PlayerInput>(
          create: () => PlayerInputCubit(
            keyDownCubit: keyDownCubit,
            keyUpCubit: keyUpCubit,
          ),
        ),
      ],
      children: components,
    );
    await add(blocProviders);

    camera.follow(player);
  }

  Future<List<Component>> _loadMap() async {
    final components = <Component>[];

    /// Load Tiled Map
    map = await TiledComponent.load(
      'map_1.tmx',
      Vector2.all(32),
      prefix: 'assets/maps/',
      useAtlas: !kIsWeb,
      layerPaintFactory: !kIsWeb
          ? null
          : (_) => Paint()
            ..isAntiAlias = false
            ..filterQuality = FilterQuality.medium,
    );
    components.add(map);

    /// Load Walls
    final walls = map.tileMap.getLayer<ObjectGroup>('Walls')!;
    for (final wall in walls.objects) {
      final wallComponent = Wall(position: wall.position, size: wall.size);
      components.add(wallComponent);
    }

    /// Load objects
    final objects = map.tileMap.getLayer<ObjectGroup>('Objects')!;
    for (final obj in objects.objects) {
      components.add(factory.create(obj));
    }

    return components;
  }
}
