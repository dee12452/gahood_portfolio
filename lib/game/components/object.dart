import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:gahood_portfolio/game/components/degree.dart';
import 'package:gahood_portfolio/game/components/interactable.dart';

class ObjectFactory {
  const ObjectFactory();

  Component create(TiledObject object) {
    final cls = object.class_;
    if (cls == 'interactable') {
      final interactionId =
          object.properties.getValue<String>('interactionId')!;
      return InteractableComponent(
        position: object.position,
        size: object.size,
        interactionId: interactionId,
      );
    } else if (cls == 'degree') {
      final tileX = object.properties.getValue<int>('interactTileOffsetX')!;
      final tileY = object.properties.getValue<int>('interactTileOffsetY')!;
      final offset = Vector2(tileX * 32, tileY * 32);
      return Degree(
        rawPos: object.position,
        interactionOffset: offset,
      );
    } else {
      throw UnsupportedError('Unsuppored object type ${object.class_}');
    }
  }
}
