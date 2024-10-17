import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:gahood_portfolio/game/components/degree.dart';
import 'package:gahood_portfolio/game/components/direction.dart';

class ObjectFactory {
  const ObjectFactory();

  Component create(TiledObject object) {
    if (object.class_ == 'degree') {
      final direction = Direction.fromInt(
        object.properties.getValue<int>('interactDirection')!,
      )!;
      final tileX = object.properties.getValue<int>('interactTileOffsetX')!;
      final tileY = object.properties.getValue<int>('interactTileOffsetY')!;
      final offset = Vector2(tileX * 32, tileY * 32);
      return Degree(
        rawPos: object.position,
        interactionOffset: offset,
        interactionDirection: direction,
      );
    } else {
      throw UnsupportedError('Unsuppored object type ${object.class_}');
    }
  }
}
