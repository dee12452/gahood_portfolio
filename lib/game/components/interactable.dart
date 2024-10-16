import 'package:gahood_portfolio/game/components/direction.dart';

mixin Interactable {
  bool canInteract(Direction facingDirection);
  void interact();
}
