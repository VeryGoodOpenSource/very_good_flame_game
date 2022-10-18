import 'dart:ui';

import 'package:flame/game.dart';
import 'package:very_good_flame_game/game/game.dart';

class VeryGoodFlameGame extends FlameGame with HasTappables {
  VeryGoodFlameGame() {
    images.prefix = '';
  }

  int counter = 0;

  @override
  Color backgroundColor() => const Color(0xFF2A48DF);

  @override
  Future<void> onLoad() async {
    camera.zoom = 8;

    await add(Unicorn(position: size / 2));
  }
}
