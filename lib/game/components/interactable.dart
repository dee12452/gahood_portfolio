import 'package:gahood_portfolio/game/direction.dart';

mixin Interactable {
  bool canInteract(Direction facingDirection);
  void interact();
}
