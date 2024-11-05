import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:gahood_portfolio/game/components/adam.dart';
import 'package:gahood_portfolio/game/components/bot.dart';
import 'package:gahood_portfolio/game/components/computer.dart';
import 'package:gahood_portfolio/game/components/degree.dart';
import 'package:gahood_portfolio/game/components/hazel.dart';
import 'package:gahood_portfolio/game/components/interactable.dart';
import 'package:gahood_portfolio/game/components/resume.dart';

class ObjectFactory {
  const ObjectFactory();

  Component create(TiledObject object) {
    final cls = object.class_;
    if (cls == 'interactable') {
      final interactionId =
          object.properties.getValue<String>('interactionId')!;
      return BasicInteractable(
        position: object.position,
        size: object.size,
        interactionId: interactionId,
      );
    } else if (cls == 'hazel') {
      return Hazel(rawPos: object.position);
    } else if (cls == 'adam') {
      return Adam(rawPos: object.position);
    } else if (cls == 'bot') {
      return Bot(rawPos: object.position);
    } else if (cls == 'computer') {
      return Computer(
        position: object.position,
        size: object.size,
      );
    } else if (cls == 'resume') {
      final tileX = object.properties.getValue<int>('interactTileOffsetX')!;
      final tileY = object.properties.getValue<int>('interactTileOffsetY')!;
      final offset = Vector2(tileX * 32, tileY * 32);
      return Resume(
        rawPos: object.position,
        interactionOffset: offset,
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
