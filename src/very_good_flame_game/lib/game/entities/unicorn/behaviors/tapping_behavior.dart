import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:very_good_flame_game/game/game.dart';

class TappingBehavior extends TappableBehavior<Unicorn>
    with HasGameRef<VeryGoodFlameGame> {
  @override
  bool onTapDown(TapDownInfo info) {
    if (parent.isAnimationPlaying()) {
      return true;
    }
    gameRef.counter++;
    parent.playAnimation();
    return false;
  }
}
