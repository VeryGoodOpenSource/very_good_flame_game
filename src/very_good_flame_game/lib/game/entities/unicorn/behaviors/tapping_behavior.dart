import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:very_good_flame_game/game/game.dart';

class TappingBehavior extends TappableBehavior<Unicorn> {
  @override
  bool onTapDown(TapDownInfo info) {
    if (parent.isAnimationPlaying()) {
      return true;
    }
    parent.playAnimation();
    return false;
  }
}
