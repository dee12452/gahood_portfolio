import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:gahood_portfolio/game/components/degree.dart';
import 'package:gahood_portfolio/game/components/direction.dart';
import 'package:gahood_portfolio/game/components/wall.dart';

class GahoodWorld extends World with HasCollisionDetection {
  late final TiledComponent map;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    map = await TiledComponent.load(
      'map_1.tmx',
      Vector2.all(32),
      prefix: 'assets/maps/',
    );
    add(map);

    final walls = map.tileMap.getLayer<ObjectGroup>('Walls')!;
    for (final wall in walls.objects) {
      final wallComponent = Wall(position: wall.position, size: wall.size);
      add(wallComponent);
    }

    final objects = map.tileMap.getLayer<ObjectGroup>('Objects')!;
    for (final obj in objects.objects) {
      if (obj.class_ == 'degree') {
        final direction = Direction.fromInt(
          obj.properties.getValue<int>('interactDirection')!,
        )!;
        final tileX = obj.properties.getValue<int>('interactTileX')!;
        final tileY = obj.properties.getValue<int>('interactTileY')!;
        final pos = Vector2(tileX * 32, tileY * 32);
        final degree = Degree(
          rawPos: obj.position,
          interactionPosition: pos,
          interactionDirection: direction,
        );
        add(degree);
      }
    }
  }
}
