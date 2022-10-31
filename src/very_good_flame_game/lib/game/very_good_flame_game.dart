import 'dart:ui';

import 'package:flame/game.dart';
import 'package:very_good_flame_game/game/game.dart';
import 'package:very_good_flame_game/l10n/l10n.dart';

class VeryGoodFlameGame extends FlameGame with HasTappables {
  VeryGoodFlameGame({
    required this.l10n,
  }) {
    images.prefix = '';
  }

  final AppLocalizations l10n;

  int counter = 0;

  @override
  Color backgroundColor() => const Color(0xFF2A48DF);

  @override
  Future<void> onLoad() async {
    camera.zoom = 8;

    await add(CounterComponent(position: (size / 2)..sub(Vector2(0, 16))));
    await add(Unicorn(position: size / 2));
  }
}
