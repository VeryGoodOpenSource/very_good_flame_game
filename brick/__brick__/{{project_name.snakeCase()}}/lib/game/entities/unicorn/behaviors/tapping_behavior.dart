// Copyright (c) {{current_year}}, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:audioplayers/audioplayers.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:{{project_name.snakeCase()}}/game/game.dart';
import 'package:{{project_name.snakeCase()}}/gen/assets.gen.dart';

class TappingBehavior extends TappableBehavior<Unicorn>
    with HasGameRef<VeryGoodFlameGame> {
  @override
  bool onTapDown(TapDownInfo info) {
    if (parent.isAnimationPlaying()) {
      return true;
    }
    gameRef.counter++;
    parent.playAnimation();

    gameRef.effectPlayer.play(AssetSource(Assets.audio.effect));

    return false;
  }
}
