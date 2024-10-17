import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:gahood_portfolio/game/components/object.dart';
import 'package:gahood_portfolio/game/components/wall.dart';

class GahoodWorld extends World with HasCollisionDetection {
  final ObjectFactory factory;
  late final TiledComponent map;

  GahoodWorld({this.factory = const ObjectFactory()});

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    await loadMap();
  }

  Future<void> loadMap() async {
    /// Load Tiled Map
    map = await TiledComponent.load(
      'map_1.tmx',
      Vector2.all(32),
      prefix: 'assets/maps/',
    );
    add(map);

    /// Load Walls
    final walls = map.tileMap.getLayer<ObjectGroup>('Walls')!;
    for (final wall in walls.objects) {
      final wallComponent = Wall(position: wall.position, size: wall.size);
      add(wallComponent);
    }

    /// Load objects
    final objects = map.tileMap.getLayer<ObjectGroup>('Objects')!;
    for (final obj in objects.objects) {
      add(factory.create(obj));
    }
  }
}
